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
