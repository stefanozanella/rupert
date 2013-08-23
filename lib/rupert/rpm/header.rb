module Rupert
  class RPM
    class Header
      # Map of all available tags and their numerical code.
      #
      # To each tag corresponds a direct method that returns the value
      # associated to it.
      TAGS = {
        :name       => 1000,
        :version    => 1001,
        :release    => 1002,
        :size       => 1009,
        :dirindexes => 1116,
        :basenames  => 1117,
        :dirnames   => 1118
      }.freeze

      # Creates a new header.
      #
      # @param index [Rupert::RPM::Index] index structure holding actual
      #              information
      def initialize(index)
        @index = index
      end

      TAGS.keys.each do |field|
        define_method(field) do
          @index.get(TAGS[field])
        end
      end
    end
  end
end
