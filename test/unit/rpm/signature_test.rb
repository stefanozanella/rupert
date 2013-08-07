require 'test_helper'

describe Rupert::RPM::Signature do
  let(:md5_signature_tag) { Rupert::RPM::Signature::MD5_TAG }
  let(:index)             { mock }
  let(:signature)         { Rupert::RPM::Signature.new(index) }

  it "maps the MD5 stored in the index" do
    index.expects(:get).once.with(md5_signature_tag)

    signature.md5
  end
end
