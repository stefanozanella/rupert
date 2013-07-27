require 'test_helper'

describe Rupture::RPM::Lead do
  context "when reading a proper RPM" do
    let(:rpm_version_raw)         { ascii("\x02\x01") }
    let(:binary_type_raw)         { ascii("\x00\x00") }
    let(:source_type_raw)         { ascii("\x00\x01") }
    let(:archnum_raw)             { ascii("\x00\x01") }
    let(:pkg_name_raw)            { ascii(pad("awesomepkg-1.0-127.fedora19", 66)) }
    let(:os_raw)                  { ascii("\x00\x01") }
    let(:sig_type_header_raw)     { ascii("\x00\x05") }
    let(:unknown_sig_type_raw)    { ascii("\x03\x03") }
    let(:reserved_string_raw)     { ascii(null(16)) }

    let(:rpm_version)             { "#{Rupture::RPM::Lead::MAGIC}#{rpm_version_raw}" }
    let(:binary_type)             { "#{rpm_version}#{binary_type_raw}" }
    let(:source_type)             { "#{rpm_version}#{source_type_raw}" }
    let(:arch)                    { "#{binary_type}#{archnum_raw}" }
    let(:pkg_name)                { "#{arch}#{pkg_name_raw}" }
    let(:os)                      { "#{pkg_name}#{os_raw}" }
    let(:signature_type_header)   { "#{os}#{sig_type_header_raw}" }
    let(:unknown_signature_type)  { "#{os}#{unknown_sig_type_raw}" }
    let(:reserved_bits)           { "#{signature_type_header}#{reserved_string_raw}" }
    let(:additional_content)      { "#{reserved_bits}this_is_not_part_of_the_lead" }
  
    it "parses RPM major and minor version numbers" do
      lead_with(rpm_version).rpm_version_major.must_equal 2
      lead_with(rpm_version).rpm_version_minor.must_equal 1
    end
  
    it "outputs RPM version number if common string format" do
      lead_with(rpm_version).rpm_version.must_equal "2.1"
    end 
  
    it "tells if a file is recognized as an RPM or not" do
      assert lead_with(rpm_version).rpm?,
             "failed to recognize the file as an RPM"
    end

    it "recognizes RPM as binary" do
      assert lead_with(binary_type).binary_type?,
             "failed to recognize RPM as of binary type"
    end

    it "recognizes RPM as source" do
      assert lead_with(source_type).source_type?,
             "failed to recognize RPM as of source type"
    end

    it "tells which architecture the package is built for" do
      lead_with(arch).arch.must_equal "i386/x86_64"
    end

    it "tells the package name" do
      lead_with(pkg_name).name.must_equal "awesomepkg-1.0-127.fedora19"
    end

    it "tells the os for which the package was built" do
      lead_with(os).os.must_equal "Linux"
    end

    it "tells whether the package is signed or not" do
      assert lead_with(signature_type_header).signed?,
             "expected to recognize the RPM as signed, but it was not"

      refute lead_with(unknown_signature_type).signed?,
             "expected to recognize the RPM as NOT signed, but it was"
    end

    it "exposes the reserved bits at the end of the lead" do
      lead_with(reserved_bits).reserved.length.must_equal 16
    end

    it "can parse an incoming IO returning itself and the remaining part for
        subsequent elaboration" do
      lead, scrap = Rupture::RPM::Lead.chomp(io(additional_content))

      lead.must_be_instance_of Rupture::RPM::Lead
      scrap.read.must_equal "this_is_not_part_of_the_lead"
    end
  end

  context "when reading an invalid RPM" do
    let(:invalid_magic) { "\x00\x01\x02\x03" }
  
    it "recognizes the file is not an RPM" do
      refute lead_with(invalid_magic).rpm?,
             "failed to recognize the file as NOT an RPM"
    end
  end

  context "when reading an empty file" do
    let(:empty_lead) { lead_from "" }
  
    it "recognizes the file is not an RPM" do
      refute empty_lead.rpm?,
             "failed to recognize the file as NOT an RPM"
    end
  end
end
