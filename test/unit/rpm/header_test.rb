require 'test_helper'

describe Rupert::RPM::Header do
  let(:name_tag)       { Rupert::RPM::Header::NAME_TAG }
  let(:version_tag)    { Rupert::RPM::Header::VERSION_TAG }
  let(:size_tag)       { Rupert::RPM::Header::SIZE_TAG }
  let(:basenames_tag)  { Rupert::RPM::Header::BASENAMES_TAG }
  let(:dirnames_tag)   { Rupert::RPM::Header::DIRNAMES_TAG }
  let(:dirindexes_tag) { Rupert::RPM::Header::DIRINDEXES_TAG }

  let(:index)  { mock }
  let(:header) { Rupert::RPM::Header.new index }
  
  it "maps RPM name stored in the header" do
    index.expects(:get).once.with(name_tag)

    header.name
  end

  it "maps RPM version stored in the header" do
    index.expects(:get).once.with(version_tag)

    header.version
  end

  it "maps RPM uncompressed size stored in the header" do
    index.expects(:get).once.with(size_tag)

    header.uncompressed_size
  end

  it "maps RPM basenames stored in the header" do
    index.expects(:get).once.with(basenames_tag)

    header.basenames
  end

  it "maps RPM dirnames stored in the header" do
    index.expects(:get).once.with(dirnames_tag)

    header.dirnames
  end

  it "maps RPM dirindexes stored in the header" do
    index.expects(:get).once.with(dirindexes_tag)

    header.dirindexes
  end
end
