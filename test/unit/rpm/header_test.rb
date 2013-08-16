require 'test_helper'

describe Rupert::RPM::Header do
  let(:index)  { mock }
  let(:tags)   { Rupert::RPM::Header::TAGS }
  let(:header) { Rupert::RPM::Header.new index }
  
  it "maps RPM name stored in the header" do
    index.expects(:get).once.with(tags[:name])

    header.name
  end

  it "maps RPM version stored in the header" do
    index.expects(:get).once.with(tags[:version])

    header.version
  end

  it "maps RPM uncompressed size stored in the header" do
    index.expects(:get).once.with(tags[:size])

    header.size
  end

  it "maps RPM basenames stored in the header" do
    index.expects(:get).once.with(tags[:basenames])

    header.basenames
  end

  it "maps RPM dirnames stored in the header" do
    index.expects(:get).once.with(tags[:dirnames])

    header.dirnames
  end

  it "maps RPM dirindexes stored in the header" do
    index.expects(:get).once.with(tags[:dirindexes])

    header.dirindexes
  end
end
