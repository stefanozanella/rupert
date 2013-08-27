require 'test_helper'

describe Rupert::RPM::File do
  describe "comparing paths" do
    let(:a_file)       { Rupert::RPM::File.new("/a/file") }
    let(:another_file) { Rupert::RPM::File.new("/another/file") }
    let(:same_file)    { a_file.dup }

    it "can be directly compared to a string, both ways" do
      "/a/file".must_equal a_file
      a_file.must_equal "/a/file"
    end

    it "can be compared to another RPM file" do
      a_file.must_equal same_file
      a_file.wont_equal another_file
    end
  end

  describe "comparing paths and sizes" do
    let(:a_file)       { Rupert::RPM::File.new("/a/file", 1234) }
    let(:another_file) { Rupert::RPM::File.new("/a/file", 4567) }
    let(:same_file)    { a_file.dup }

    it "says two files are the same if they have same size and path" do
      a_file.must_equal same_file
    end

    it "won't say two files are the same if they have different sizes" do
      a_file.wont_equal another_file
    end
  end
end
