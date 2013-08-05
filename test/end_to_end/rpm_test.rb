require 'test_helper'

describe Rupert::RPM do
  let(:valid_rpm)   { fixture('rpm-4.8.0-32.el6.x86_64.rpm') }
  let(:invalid_rpm) { fixture('notanrpm-0.0.1-1.el6.noarch.rpm') }
  let(:bin_rpm)     { fixture('rpm-4.8.0-32.el6.x86_64.rpm') }
  let(:src_rpm)     { fixture('redhat-lsb-4.0-7.el6.centos.src.rpm') }

  let(:rpm)         { Rupert::RPM.load(valid_rpm) }
  let(:binary_rpm)  { Rupert::RPM.load(bin_rpm) }
  let(:source_rpm)  { Rupert::RPM.load(src_rpm) }

  it "correctly loads a valid RPM" do
    Rupert::RPM.load(valid_rpm)
  end

  it "raises an error if the RPM is not in valid format" do
    proc {
      Rupert::RPM.load(invalid_rpm)
    }.must_raise Rupert::NotAnRPM
  end

  it "tells the package's name" do
    rpm.name.must_equal "rpm"
  end

  it "tells the package uncompressed size (in bytes)" do
    rpm.uncompressed_size.must_equal 2031240
  end

  it "tells the full name of the files contained in the package" do
    rpm.filenames.length.must_equal 0x8c

    rpm.filenames.must_include "/bin/rpm"
    rpm.filenames.must_include "/usr/share/doc/rpm-4.8.0/ChangeLog.bz2"
    rpm.filenames.must_include "/var/lib/rpm/__db.009"
  end

  it "knows which version of RPM the file is" do
    rpm.rpm_version.must_equal "3.0"
  end

  it "tells which architecture the package is built for" do
    rpm.rpm_arch.must_equal "i386/x86_64"
  end

  it "tells if the file is a binary or source RPM" do
    binary_rpm.must_be :binary?
    binary_rpm.wont_be :source?

    source_rpm.must_be :source?
    source_rpm.wont_be :binary?
  end

  it "tells the operating system for which the package has been built" do
    rpm.os.must_equal "Linux"
  end

  it "tells if package is signed" do
    rpm.must_be :signed?
  end
end
