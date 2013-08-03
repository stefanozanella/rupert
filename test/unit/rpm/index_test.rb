require 'test_helper'

describe Rupert::RPM::Index do
  let(:entry)   { Rupert::RPM::Entry.new(3145, nil, nil, nil) }
  let(:store)   { mock }
  let(:index)   { Rupert::RPM::Index.new(entry, store) }

  it "retrieves data associated to a specific tag" do
    entry.expects(:resolve).once.with(store)

    index.get(3145)
  end
end
