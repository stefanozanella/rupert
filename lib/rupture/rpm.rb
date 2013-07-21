require 'rupture/errors'

module Rupture
  class RPM
    class << self
      # The magic header that identifies an RPM beyond a shadow of a doubt, as
      # every good RPM starts with hex `ed ab ee db`.
      MAGIC = "\xed\xab\xee\xdb".force_encoding(Encoding::ASCII_8BIT).freeze

      # Loads a RPM file and parses its structure
      #
      # @param filename [String] filename of the RPM to load
      # @return TODO
      def load(filename)
        raise NotAnRPM, 
          "File #{filename} doesn't contain expected magic header" unless rpm?(filename)
      end

      # Tells whether given filename points to a valid RPM or not.
      #
      # @param filename [String] filename to inspect
      # @return `true` if file starts with the correct magic header
      def rpm?(filename)
        magic(File.new(filename, 'r')) == MAGIC
      end

      private

      # @param file [IO] RPM file IO handler
      # @return [String] first 4 bytes of the file
      def magic(io)
        io.seek(0, IO::SEEK_SET)
        io.read(4)
      end
    end
  end
end
