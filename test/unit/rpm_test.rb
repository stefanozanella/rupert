require 'test_helper'

describe Rupert::RPM do
  let(:signature)         { mock }
  let(:header)            { mock }
  let(:rpm)               { Rupert::RPM.new(nil, signature, signed_content, header) }
  let(:corrupted_rpm)     { Rupert::RPM.new(nil, signature, corrupted_content, header) }
  let(:signed_content)    { ascii("\x01\x02\x03\x04") }
  let(:corrupted_content) { ascii("\xf4\x04\x57\x1e") }

  it "exposes MD5 checksum in base64 encoding" do
    random_md5 = random_ascii(128)
    signature.stubs(:md5).returns(random_md5)

    rpm.md5.must_equal base64(random_md5)
  end

  it "correctly verifies integrity of pristine and corrupted packages" do
    signature.stubs(:md5).returns(md5(signed_content))

    assert rpm.intact?,
           "expected RPM to be intact, but it wasn't"

    refute corrupted_rpm.intact?,
           "expected RPM not to be intact, but it was"
  end

  it "exposes RPM name stored in the header" do
    header.stubs(:name).returns("package-name")

    rpm.name.must_equal("package-name")
  end

  it "exposes RPM version stored in the header" do
    header.stubs(:version).returns("0.0.0")

    rpm.version.must_equal("0.0.0")
  end

  it "exposes RPM release string stored in the header" do
    header.stubs(:release).returns("111.abc")

    rpm.release.must_equal("111.abc")
  end

  it "exposes RPM target OS string stored in the header" do
    header.stubs(:os).returns("some_crazy_os")

    rpm.os.must_equal("some_crazy_os")
  end

  it "exposes RPM target architecture string stored in the header" do
    header.stubs(:arch).returns("unusual_architecture")

    rpm.arch.must_equal("unusual_architecture")
  end

  it "exposes RPM license name stored in the header" do
    header.stubs(:license).returns("WTFPL")

    rpm.license.must_equal("WTFPL")
  end

  it "exposes RPM payload format name stored in the header" do
    header.stubs(:payload_format).returns("plain")

    rpm.payload_format.must_equal("plain")
  end

  it "exposes RPM payload compressor name stored in the header" do
    header.stubs(:payload_compressor).returns("bzip2")

    rpm.payload_compressor.must_equal("bzip2")
  end

  it "exposes RPM payload flags stored in the header" do
    header.stubs(:payload_flags).returns("whoknows?")

    rpm.payload_flags.must_equal("whoknows?")
  end

  it "exposes RPM build host name stored in the header" do
    header.stubs(:build_host).returns("abc.example.com")

    rpm.build_host.must_equal("abc.example.com")
  end

  it "exposes RPM build time stored in the header" do
    header.stubs(:build_date).returns(123456)

    rpm.build_date.must_equal(Time.at(123456).to_datetime)
  end

  it "exposes RPM packager info stored in the header" do
    header.stubs(:packager).returns("John Doe <john@doe.com>")

    rpm.packager.must_equal("John Doe <john@doe.com>")
  end

  it "exposes RPM vendor info stored in the header" do
    header.stubs(:vendor).returns("Example Inc.")

    rpm.vendor.must_equal("Example Inc.")
  end

  it "exposes package URL stored in the header" do
    header.stubs(:url).returns("http://example.com")

    rpm.url.must_equal("http://example.com")
  end

  it "exposes package's source RPM name stored in the header" do
    header.stubs(:source_rpm).returns("myrpm-1.0.0-1.src.rpm")

    rpm.source_rpm.must_equal("myrpm-1.0.0-1.src.rpm")
  end

  it "exposes package's group name stored in the header" do
    header.stubs(:group).returns("base software")

    rpm.group.must_equal("base software")
  end

  it "exposes package's summary stored in the header" do
    header.stubs(:summary).returns("silly package")

    rpm.summary.must_equal("silly package")
  end

  it "exposes RPM uncompressed size stored in the header" do
    header.stubs(:size).returns(1234)

    rpm.uncompressed_size.must_equal 1234
  end

  it "exposes RPM basenames stored in the header" do
    header.stubs(:basenames).returns(["file1", "file1", "file2"])
    header.stubs(:dirnames).returns(["/dir1", "/dir2"])
    header.stubs(:dirindexes).returns([0, 1, 0])

    rpm.filenames.must_equal [ "/dir1/file1", "/dir2/file1", "/dir1/file2" ]
  end
end
