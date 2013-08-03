require 'test_helper'

describe Rupert::RPM::Entry do
  context "when asked for binary data" do
    let(:store) { io(ascii("\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a")) }
    let(:entry) { Rupert::RPM::Entry.new(nil, 7, 4, 5) }

    it "fetches binary data which length and position is given by the entry" do
      data = entry.resolve(store)
      data.must_equal ascii("\x04\x05\x06\x07\x08")
    end
  end

  context "when asked for a null-terminated string" do
    let(:store) { io(ascii("\x00\x01Null-terminated string.\x00LOLTHISCRAP")) }
    let(:entry) { Rupert::RPM::Entry.new(nil, 6, 2, 1) }

    it "retrieves all chars starting from entry offset until it encounters `\x00`" do
      data = entry.resolve(store)
      data.must_equal "Null-terminated string."
    end
  end
end
