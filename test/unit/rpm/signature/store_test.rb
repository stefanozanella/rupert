require 'test_helper'

describe Rupert::RPM::Signature::Store do
  let(:raw_io)  { io(ascii("\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a")) }
  let(:entry)   { Rupert::RPM::Signature::Entry.new(nil, 7, 4, 5) }
  let(:store)   { Rupert::RPM::Signature::Store.new(raw_io) }

  it "fetches a raw chunck of data given the entry that points to it" do
    data = store.fetch(entry)
    data.must_equal ascii("\x04\x05\x06\x07\x08")
  end
end
