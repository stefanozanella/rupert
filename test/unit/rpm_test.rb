require 'test_helper'

describe Rupert::RPM do
  let(:md5_signature_tag) { Rupert::RPM::Signature::MD5_TAG }
  let(:name_tag)          { Rupert::RPM::Header::NAME_TAG }
  let(:size_tag)          { Rupert::RPM::Header::SIZE_TAG }
  let(:basenames_tag)     { Rupert::RPM::Header::BASENAMES_TAG }
  let(:dirnames_tag)     { Rupert::RPM::Header::DIRNAMES_TAG }
  let(:dirindexes_tag)     { Rupert::RPM::Header::DIRINDEXES_TAG }
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
    header.expects(:get).once.with(name_tag)

    rpm.name
  end

  it "exposes RPM uncompressed size stored in the header" do
    header.expects(:get).once.with(size_tag)

    rpm.uncompressed_size
  end

  it "exposes RPM basenames stored in the header" do
    header.expects(:get).at_least_once.with(basenames_tag).returns(["file1", "file1", "file2"])
    header.expects(:get).at_least_once.with(dirnames_tag).returns(["/dir1", "/dir2"])
    header.expects(:get).at_least_once.with(dirindexes_tag).returns([0, 1, 0])

    rpm.filenames.must_equal [ "/dir1/file1", "/dir2/file1", "/dir1/file2" ]
  end
end
