module Rupert
  class RPM
    class Lead
      # Lead has a fixed length
      LEAD_LENGTH = 96.freeze # byte

      # The magic header that identifies an RPM beyond a shadow of a doubt, as
      # every good RPM starts with hex +ed ab ee db+.
      MAGIC = "\xed\xab\xee\xdb".force_encoding(Encoding::ASCII_8BIT).freeze

      # RPM of type binary
      TYPE_BINARY = 0.freeze

      # RPM of type source
      TYPE_SOURCE = 1.freeze

      @@arch_map = {
        1 => "i386/x86_64"
      }.freeze

      @@os_map = {
        1 => "Linux"
      }.freeze

      # Only valid and recognized signature type
      SIGNATURE_TYPE_HEADER = 5.freeze

      # Chomps given IO, producing a {Lead} object and returning the remaining
      # part for subsequent processing.
      #
      # Lead data is expected to begin at IO start, so returned scrap is
      # basically the input IO without its first
      # {Rupert::RPM::Lead::LEAD_LENGTH} bytes.
      #
      # @param io [IO] IO object containing lead data at its start, possibly
      #           with additional bytes at the end 
      #
      # @return [Rupert::RPM::Lead, IO] the lead object corresponding to the
      #         data at the beginning of the IO, and the part of the input remaining
      #         after parsing.
      def self.chomp(io)
        [ self.new(io), io ]
      end

      # Initializes a lead section, parsing given IO
      #
      # @param lead [IO] An IO containing the lead information at the start
      def initialize(lead)
        lead_data = lead.read(LEAD_LENGTH)
        parse(lead_data) if lead_data
      end

      # Major number of the RPM version used to format the package
      #
      # @return [Fixnum] RPM major version number 
      def rpm_version_major
        @rpm_major
      end

      # Minor number of the RPM version used to format the package
      #
      # @return [Fixnum] RPM minor version number 
      def rpm_version_minor
        @rpm_minor
      end

      # RPM version used to format the package
      #
      # @return [String] RPM version in <major>.<minor> format
      def rpm_version
        "#{rpm_version_major}.#{rpm_version_minor}"
      end

      # Tells if the file is recognized as an RPM or not
      #
      # @return +true+ if magic number is found at lead's start, +false+
      #          otherwise
      def rpm?
        @magic == MAGIC
      end

      # @return +true+ if lead reports RPM as of binary type
      def binary_type?
        @type == TYPE_BINARY
      end

      # @return +true+ if lead reports RPM as of source type
      def source_type?
        @type == TYPE_SOURCE
      end

      # The architecture the package was built for. A list of supported
      # architectures can be found in _/usr/lib/rpm/rpmrc_ on RedHat based
      # systems.
      #
      # @return [String] a string representing the architecture name(s)
      def arch
        @@arch_map[@archnum]
      end

      # The name of the package
      #
      # @return [String] package name in the form <name>-<version>-<rev>.<suffix>
      def name
        @name
      end

      # OS for which the package was built
      #
      # @return [String] OS canonical name as defined in _/usr/lib/rpm/rpmrc_
      def os
        @@os_map[@osnum]
      end

      # @return +true+ if the RPM is recognized as being signed, +false+ otherwise
      def signed?
        @signature_type == SIGNATURE_TYPE_HEADER
      end

      # String of reserved bits. It's here for completeness of the lead's
      # implementation but it isn't intended to be actually used
      #
      # @return [String] the raw 16 bytes long reserved string at the end of
      #         the lead
      def reserved
        @reserved
      end

      private

      # :nodoc
      # The format string passed to +unpack+ to parse the lead
      LEAD_FORMAT = "A4CCnnZ66nna16".freeze

      # :nodoc
      # Unpacks lead raw bytes into its semantic components
      def parse(lead_data)
        @magic, @rpm_major, @rpm_minor, @type, @archnum, @name, @osnum,
            @signature_type, @reserved = lead_data.unpack(LEAD_FORMAT)
      end
    end
  end
end
