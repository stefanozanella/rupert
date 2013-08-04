module Rupert
  class RPM
    class Header
      NAME_TAG = 1000.freeze
      SIZE_TAG = 1009.freeze

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
        @index.get NAME_TAG
      end

      # Package uncompressed size (bytes).
      #
      # @return [Fixnum]
      def uncompressed_size
        @index.get SIZE_TAG
      end
    end
  end
end
