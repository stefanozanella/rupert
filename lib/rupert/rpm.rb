require 'rupert/errors'
require 'rupert/parser'
require 'rupert/rpm/lead'
require 'rupert/rpm/signature'
require 'rupert/rpm/header'

require 'base64'

module Rupert
  class RPM
    class << self
      # Loads a RPM file and parses its structure
      #
      # @param filename [String] filename of the RPM to load
      # @return [Rupert::RPM] the parsed RPM
      def load(filename)
        raise NotAnRPM, 
          "File #{filename} isn't a valid RPM" unless rpm?(filename)

        raw_io = File.open(filename, 'r')
        rpm = Parser.new(raw_io).parse
        raw_io.close

        return rpm
      end

      # Tells whether given filename points to a valid RPM or not.
      #
      # @param filename [String] filename to inspect
      # @return +true+ if file starts with the correct magic header
      def rpm?(filename)
        Lead.new(File.open(filename, 'r')).rpm?
      end
    end

    # Initialize the RPM object, given its components.
    #
    # This method is not intended to be used to instantiate RPM objects
    # directly. Instead, use {Rupert::RPM.load} for a more straightforward
    # alternative.
    #
    # @param lead [Rupert::RPM::Lead] RPM lead section
    # @param signature [Rupert::RPM::Signature] RPM signature information
    # @param content [String] Raw content found after the signature structure
    # @param header [Rupert::RPM::Header] RPM header holding package metadata
    def initialize(lead, signature, content, header)
      @lead, @signature, @content, @header = lead, signature, content, header
    end

    # RPM version used to encode the package.
    #
    # @return [String] the RPM version in +<major>.<minor>+ format
    def rpm_version
      @lead.rpm_version
    end

    # @return +true+ if the RPM is of type binary, +false+ otherwise
    def binary?
      @lead.binary_type?
    end

    # @return +true+ if the RPM is of type source, +false+ otherwise
    def source?
      @lead.source_type?
    end

    # Which architecture the package was built for, e.g. +i386/x86_64+ or
    # +arm+
    #
    # @return [String] package architecture name
    def rpm_arch
      @lead.arch
    end

    # Full package name
    #
    # @return [String] package name in the form +<name>-<version>-<rev>.<suffix>+
    def name
      @header.name
    end

    # Package version
    #
    # @return [String] package version as defined in the spec file
    def version
      @header.version
    end

    # Package release string
    #
    # @return [String] package release string as defined in the spec file
    def release
      @header.release
    end

    # OS for which the package was built
    #
    # @return [String] package target os as defined in the spec file
    def os
      @header.os
    end

    # Target architecture of the package
    #
    # @return [String] the name of the architecture the package was built for
    def arch
      @header.arch
    end

    # The name of the license used for the package
    #
    # @return [String] license name as defined in the spec file
    def license
      @header.license
    end

    # The format of package's payload.
    #
    # @return [String] payload format name
    def payload_format
      @header.payload_format
    end

    # The compression function applied to package's payload.
    #
    # @return [String] payload compressor name
    def payload_compressor
      @header.payload_compressor
    end

    # The PAYLOADFLAGS metadata field.
    #
    # The purpose of this field is still opaque for me; also, note that
    # according to
    # http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch-package-structure.html
    # it should always be set to +9+. But, in practice, this is now always the
    # case.
    #
    # @return [String] PAYLOADFLAGS field
    def payload_flags
      @header.payload_flags
    end

    # The hostname of the build machine the package has been built on.
    #
    # @return [String] FQDN of the host the package has been built on
    def build_host
      @header.build_host
    end

    # The point in time at which the package was built.
    #
    # @return [DateTime] when the package was built
    def build_date
      Time.at(@header.build_date).to_datetime
    end

    # Information about the packager.
    #
    # @return [String] usually info like full name and email of the packager
    def packager
      @header.packager
    end

    # Information about the vendor of the package.
    #
    # @return [String] package's vendor
    def vendor
      @header.vendor
    end

    # Package homepage URL.
    #
    # @return [String] package URL
    def url
      @header.url
    end

    # The group this package belongs to.
    #
    # @return [String] package group, in the form +<section>/<subsection>+
    def group
      @header.group
    end

    # Package's short description.
    #
    # @return [String] short package description
    def summary
      @header.summary
    end

    # Name of the source RPM associated to the binary package.
    #
    # @return [String] source RPM filename
    def source_rpm
      @header.source_rpm
    end

    # @return +true+ if the package is signed, +false+ otherwise
    def signed?
      @lead.signed?
    end

    # MD5 checksum stored in the package (base64 encoded). To be used to check
    # package integrity.
    #
    # *NOTE*: This is not the MD5 of the whole package; rather, the digest is
    # calculated over the header and payload, leaving out the lead and the
    # signature header. I.e., running +md5sum <myrpm>+ won't held the same
    # result as +Rupert::RPM.load('<myrpm>').md5+.
    #
    # @return [String] Base64-encoded MD5 checksum of package's header and
    #         payload, stored in the RPM itself
    def md5
      Base64.strict_encode64(@signature.md5)
    end

    # Verifies package integrity. Compares MD5 checksum stored in the package
    # with checksum calculated over header(s) and payload (archive).
    #
    # @return +true+ if package is intact, +false+ if package (either stored MD5 or
    # payload) is corrupted
    def intact?
      @signature.md5 == Digest::MD5.digest(@content)
    end

    # Package uncompressed size.
    #
    # This is the size (in bytes) of the uncompressed archive, or if you
    # prefer, package's installed size.
    #
    # *NOTE*: if reading a package built with native +rpmbuild+, this number
    # (which is stored in the RPM itself) might not be precise, as
    # this[http://rpm5.org/community/rpm-devel/2689.html] thread explains. 
    #
    # @return [Fixnum] package uncompressed size (bytes)
    def uncompressed_size
      @header.size
    end

    # List of installed files (full paths).
    #
    # @return [Array] array of +String+, with entries corresponding to 
    #         absolute filenames
    def filenames
      @header.dirindexes.map { |idx|
        @header.dirnames[idx]
      }.zip(@header.basenames).map { |dir, name|
        File.join(dir, name)
      }
    end
  end
end
