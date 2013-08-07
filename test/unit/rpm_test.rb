require 'test_helper'

describe Rupert::RPM do
  let(:md5_signature_tag) { Rupert::RPM::Signature::MD5_TAG }
  let(:signature)         { mock }
  let(:header)            { mock }
  let(:rpm)               { Rupert::RPM.new(nil, signature, signed_content, header) }
  let(:corrupted_rpm)     { Rupert::RPM.new(nil, signature, corrupted_content, header) }
  let(:signed_content)    { ascii("\x01\x02\x03\x04") }
  let(:corrupted_content) { ascii("\xf4\x04\x57\x1e") }

  it "fetches the MD5 from its index" do
    signature.expects(:get).once.with(md5_signature_tag).returns("abc")

    rpm.md5
  end

  it "correctly verifies integrity of pristine and corrupted packages" do
    signature.stubs(:get).returns(md5(signed_content))

    assert rpm.intact?,
           "expected RPM to be intact, but it wasn't"

    refute corrupted_rpm.intact?,
           "expected RPM not to be intact, but it was"
  end

  it "exposes RPM name stored in the header" do
    header.stubs(:name).returns("package-name")

    rpm.name.must_equal("package-name")
  end

  it "exposes RPM uncompressed size stored in the header" do
    header.stubs(:uncompressed_size).returns(1234)

    rpm.uncompressed_size.must_equal 1234
  end

  it "exposes RPM basenames stored in the header" do
    header.stubs(:basenames).returns(["file1", "file1", "file2"])
    header.stubs(:dirnames).returns(["/dir1", "/dir2"])
    header.stubs(:dirindexes).returns([0, 1, 0])

    rpm.filenames.must_equal [ "/dir1/file1", "/dir2/file1", "/dir1/file2" ]
  end
end
