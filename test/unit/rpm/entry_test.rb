require 'test_helper'

describe Rupert::RPM::Entry do
  describe "fetching binary data" do
    let(:store) { io(ascii("\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a")) }
    let(:entry) { Rupert::RPM::Entry.new(nil, 7, 4, 5) }

    it "fetches binary data which length and position is given by the entry" do
      entry.resolve(store).must_equal ascii("\x04\x05\x06\x07\x08")
    end
  end

  describe "fetching a single string" do
    let(:store) { io(ascii("\x00\x01Null-terminated string.\x00LOLTHISCRAP")) }
    let(:entry) { Rupert::RPM::Entry.new(nil, 6, 2, 1) }

    it "retrieves all chars starting from entry offset until it encounters `\x00`" do
      entry.resolve(store).must_equal "Null-terminated string."
    end
  end

  describe "fetching a single 32-bit integer" do
    let(:store) { io(ascii("Somecrap\x00\x12\x34\x56\x78Tail content")) }
    let(:entry) { Rupert::RPM::Entry.new(nil, 4, 9, 1) }

    it "successfully retrieves a single 32-bit integer" do
      entry.resolve(store).must_equal 0x12345678
    end
  end
end
