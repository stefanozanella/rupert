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

  it "tells the package's version" do
    rpm.version.must_equal "4.8.0"
  end

  it "tells the package's release" do
    rpm.release.must_equal "32.el6"
  end

  it "tells the package's target OS" do
    rpm.os.must_equal "linux"
  end

  it "tells the package's target architecture" do
    rpm.arch.must_equal "x86_64"
  end

  it "tells how the package is licensed" do
    rpm.license.must_equal "GPLv2+"
  end

  it "tells which format the payload is stored as" do
    rpm.payload_format.must_equal "cpio"
  end

  it "tells how the payload is compressed" do
    rpm.payload_compressor.must_equal "xz"
  end

  it "reads the PAYLOADFLAGS field" do
    rpm.payload_flags.must_equal "2"
  end

  it "reads the name of the buildhost" do
    rpm.build_host.must_equal "c6b8.bsys.dev.centos.org"
  end

  it "reads the package building datetime" do
    rpm.build_date.must_equal DateTime.parse('Fri 22 Feb 2013 03:13:55 AM CET')
  end

  it "reads the info about the packager" do
    rpm.packager.must_equal "CentOS BuildSystem <http://bugs.centos.org>"
  end

  it "reads the info about the vendor" do
    rpm.vendor.must_equal "CentOS"
  end

  it "reads the package URL" do
    rpm.url.must_equal "http://www.rpm.org/"
  end

  it "reads the group the package belongs to" do
    rpm.group.must_equal "System Environment/Base"
  end

  it "reads the package summary" do
    rpm.summary.must_equal "The RPM package management system"
  end

  it "reads the package description" do
    rpm.description.must_equal strip_heredoc(<<-desc)
      The RPM Package Manager (RPM) is a powerful command line driven
      package management system capable of installing, uninstalling,
      verifying, querying, and updating software packages. Each software
      package consists of an archive of files along with information about
      the package like its version, a description, etc.
    desc
  end

  it "reads the associated source RPM file name" do
    rpm.source_rpm.must_equal "rpm-4.8.0-32.el6.src.rpm"
  end

  it "tells the package uncompressed size (in bytes)" do
    rpm.uncompressed_size.must_equal 2031240
  end

  it "gives full info about the files contained in the package" do
    rpm.files.length.must_equal 140

    rpm.files.must_include file("/bin/rpm", 20392)
    rpm.files.must_include file("/usr/share/doc/rpm-4.8.0/ChangeLog.bz2", 491643)
    rpm.files.must_include file("/var/lib/rpm/__db.009", 0)
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

  it "tells if package is signed" do
    rpm.must_be :signed?
  end
end
