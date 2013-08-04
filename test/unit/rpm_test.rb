require 'test_helper'

describe Rupert::RPM do
  let(:md5_signature_tag) { Rupert::RPM::Signature::MD5_TAG }
  let(:name_tag)          { Rupert::RPM::Header::NAME_TAG }
  let(:size_tag)          { Rupert::RPM::Header::SIZE_TAG }
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
end
