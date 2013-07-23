require 'rupture/errors'
require 'rupture/rpm/lead'

module Rupture
  class RPM
    class << self
      # Loads a RPM file and parses its structure
      #
      # @param filename [String] filename of the RPM to load
      # @return [Rupture::RPM] the parsed RPM
      def load(filename)
        raise NotAnRPM, 
          "File #{filename} isn't a valid RPM" unless rpm?(filename)

        return self.new(File.open(filename, 'r'))
      end

      # Tells whether given filename points to a valid RPM or not.
      #
      # @param filename [String] filename to inspect
      # @return `true` if file starts with the correct magic header
      def rpm?(filename)
        Lead.new(File.open(filename, 'r')).rpm?
      end
    end

    # Parses an RPM file, given as an IO ojbect
    #
    # @param io [IO] The IO stream containing the RPM package
    def initialize(io)
      @lead = Lead.new(io)
    end

    # RPM version used to encode the package.
    #
    # @return [String] the RPM version in `<major>.<minor>` format
    def rpm_version
      @lead.rpm_version
    end

    # @return `true` if the RPM is of type binary, `false` otherwise
    def binary?
      @lead.binary_type?
    end

    # @return `true` if the RPM is of type source, `false` otherwise
    def source?
      @lead.source_type?
    end

    # Which architecture the package was built for, e.g. `i386/x86_64` or
    # `mips`
    #
    # @return [String] package architecture name
    def rpm_arch
     @lead.arch
    end

    # Full package name
    #
    # @return [String] package name in the form <name>-<version>-<rev>.<suffix>
    def name
      @lead.name
    end

    # OS for which the package was built
    #
    # @return [String] as defined in /usr/lib/rpm/rpmrc under the canonical OS
    #                  names section
    def os
      @lead.os
    end

    # @return `true` if the package is signed, `false` otherwise
    def signed?
      @lead.signed?
    end
  end
end
