require 'test_helper'

describe Rupture::RPM::Signature::Index do
  let(:entry)   { Rupture::RPM::Signature::Entry.new(1234, 7, 567, 890) }
  let(:entries) { { entry.tag => entry } } 
  let(:store)   { mock }
  let(:index)   { Rupture::RPM::Signature::Index.new(entries, store) }

  it "retrieves binary data marked with a specific tag from the store" do
    store.expects(:fetch).once.with(entry)
    
    index.get(entry.tag)
  end
end