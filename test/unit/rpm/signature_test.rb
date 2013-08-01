require 'test_helper'

describe Rupert::RPM::Signature do
  let(:md5_signature_tag) { Rupert::RPM::Signature::MD5_TAG }
  let(:index)             { mock }
  let(:signature)         { Rupert::RPM::Signature.new(index) }
  let(:pristine_content)  { ascii("\x01\x02\x03\x04") }
  let(:corrupted_content) { ascii("\xf4\x04\x57\x1e") }

  it "fetches the MD5 from its index" do
    index.expects(:get).once.with(md5_signature_tag) 

    signature.md5
  end

  it "correctly verifies integrity of pristine and corrupted packages" do
    index.stubs(:get).returns(md5(pristine_content))

    assert signature.verify_checksum(pristine_content),
           "expected pristine content to be verified correctly, but it was not"

    refute signature.verify_checksum(corrupted_content),
           "expected corrupted content not to be verified correctly, but it was"
  end
end
