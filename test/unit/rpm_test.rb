require 'test_helper'

describe Rupert::RPM do
  let(:signature)      { mock }
  let(:rpm)            { Rupert::RPM.new(nil, signature, signed_content) }
  let(:signed_content) { ascii("\x01\x02\x03\x04") }

  it "exposes the MD5 digest held by the signature" do
    signature.expects(:md5).once.returns("abc")

    rpm.md5
  end

  it "asks the signature to verify content integrity" do
    signature.expects(:verify_checksum).once.with(signed_content)

    rpm.intact?
  end
end
