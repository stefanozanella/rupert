require 'test_helper'

describe Rupert::RPM::Header do
  let(:index)  { mock }
  let(:tags)   { Rupert::RPM::Header::TAGS }
  let(:header) { Rupert::RPM::Header.new index }
  
  it "correctly maps all methods to their corresponding tag in the header" do
    [ :name,
      :version,
      :release,
      :os,
      :arch,
      :license,
      :payload_format,
      :payload_compressor,
      :payload_flags,
      :build_host,
      :build_date,
      :packager,
      :vendor,
      :url,
      :size,
      :basenames,
      :dirnames,
      :dirindexes,
    ].each do |field|
      index.expects(:get).once.with(tags[field])

      header.send(field)
    end
  end
end
