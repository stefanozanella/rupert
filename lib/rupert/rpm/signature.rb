module Rupert
  class RPM
    class Signature
      # Tag holding 128-bit MD5 checksum of header and payload
      MD5_TAG = 1004.freeze

      # Creates a new signature given its components.
      #
      # @param index [Rupert::RPM::Signature::Index] the signature index
      #              containing actual signature data
      def initialize(index)
        @index = index
      end

      # MD5 checksum contained in the RPM.
      #
      # @return [String] 128-bit MD5 checksum of RPM's header and payload, in
      #         raw binary form.
      def md5
        @index.get MD5_TAG
      end

      # Verifies if stored MD5 checksum corresponds to digest calculated over
      # given content.
      #
      # @return +true+ if stored MD5 checksum corresponds to MD5 calculated
      #         over given content, +false+ otherwise
      def verify_checksum(content)
        md5 == md5_checksum(content)
      end

      private

      # :nodoc
      # MD5 checksum of given string
      def md5_checksum(str)
        Digest::MD5.digest(str)
      end
    end
  end
end
