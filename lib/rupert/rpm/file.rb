module Rupert
  class RPM
    class File
      attr_reader :name, :size

      def initialize(name, size=0)
        @name = name
        @size = size
      end

      def ==(str)
        return @name == str if str.is_a? String

        (@name == str.name) &&
        (@size == str.size)
      end

      def to_str
        @name
      end
    end
  end
end
