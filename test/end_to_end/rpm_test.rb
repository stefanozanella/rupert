require 'test_helper'

describe Rupture::RPM do
  let(:valid_rpm)   { fixture('rpm-4.8.0-32.el6.x86_64.rpm') }
  let(:invalid_rpm) { fixture('notanrpm-0.0.1-1.el6.noarch.rpm') }
  let(:bin_rpm)     { fixture('rpm-4.8.0-32.el6.x86_64.rpm') }
  let(:src_rpm)     { fixture('redhat-lsb-4.0-7.el6.centos.src.rpm') }

  let(:rpm)         { Rupture::RPM.load(valid_rpm) }
  let(:binary_rpm)  { Rupture::RPM.load(bin_rpm) }
  let(:source_rpm)  { Rupture::RPM.load(src_rpm) }

  it "correctly loads a valid RPM" do
    Rupture::RPM.load(valid_rpm)
  end

  it "raises an error if the RPM is not in valid format" do
    proc {
      Rupture::RPM.load(invalid_rpm)
    }.must_raise Rupture::NotAnRPM
  end

  it "knows which version of RPM the file is" do
    rpm.rpm_version.must_equal "3.0"
  end

  it "tells which architecture the package is built for" do
    rpm.rpm_arch.must_equal "i386/x86_64"
  end

  it "tells if the file is a binary or source RPM" do
    assert binary_rpm.binary?, "failed to recognize RPM as binary"
    refute binary_rpm.source?, "RPM misrecognized as of source type"

    assert source_rpm.source?, "failed to recognize RPM as source"
    refute source_rpm.binary?, "RPM misrecognized as of binary type"
  end

  it "tells the package's name" do
    rpm.name.must_equal "rpm-4.8.0-32.el6"
  end

  it "tells the operating system for which the package has been built" do
    rpm.os.must_equal "Linux"
  end

  it "tells if package is signed" do
    assert rpm.signed?, "expected the package to be signed, but it was not"
  end
end