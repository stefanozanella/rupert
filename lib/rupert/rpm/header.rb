module Rupert
  class RPM
    class Header
      NAME_TAG = 1000.freeze

      def initialize(index)
        @index = index
      end

      def name
        @index.get NAME_TAG
      end
    end
  end
end
