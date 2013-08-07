module Rupert
  class RPM
    class Header
      NAME_TAG      = 1000.freeze
      SIZE_TAG      = 1009.freeze
      DIRINDEXES_TAG = 1116.freeze
      BASENAMES_TAG = 1117.freeze
      DIRNAMES_TAG  = 1118.freeze

      # Creates a new header.
      #
      # @param index [Rupert::RPM::Index] index structure holding actual
      #              information
      def initialize(index)
        @index = index
      end

      # Package name.
      #
      # @return [String]
      def name
        @index.get(NAME_TAG)
      end

      # Package uncompressed size (bytes).
      #
      # @return [Fixnum]
      def uncompressed_size
        @index.get(SIZE_TAG)
      end

      # Package files basename list.
      #
      # @return [Array] of +String+
      def basenames
        @index.get(BASENAMES_TAG)
      end

      # Installed directory list.
      #
      # @return [Array] of +String+
      def dirnames
        @index.get(DIRNAMES_TAG)
      end

      # Map between basenames and relative directories.
      #
      # @return [Array] of +Fixnum+, where each number represents an index in
      # the +dirnames+ array
      def dirindexes
        @index.get(DIRINDEXES_TAG)
      end
    end
  end
end
