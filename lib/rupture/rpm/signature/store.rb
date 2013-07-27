module Rupture
class RPM
  class Signature
    # Package information is mostly contained in headers. Headers are composed
    # of an index and a store.
    # The (raw) store holds semantic RPM information in an undefined
    # order and without any structure (i.e. by concatenating all pieces
    # together). Addressing of resources in the store is handled by header
    # entries, which define data format, position and size. Responsibility
    # of the store is to take care of extracting these pieces given proper
    # addressing information.
    class Store
      # Creates a new store by wrapping given chunck of raw data into a Store
      # object.
      #
      # @param io [IO] raw binary data carved from RPM header. Must be an IO
      #           containing only store's data (i.e. entry addresses are considered
      #           relative to 0)
      def initialize(io)
        @io = io
      end

      # Fetches data pointed by given entry.
      #
      # @param entry [Rupture::RPM::Signature::Entry] entry containing address
      #              and type of needed information
      # @return [String] binary string containing asked data
      def fetch(entry)
        @io.seek(entry.offset, IO::SEEK_SET)
        @io.read(entry.count)
      end
    end
  end
end
end
