module Rupture
  class RPM
    class Signature
      class Entry
        # Initializes a new index entry.
        #
        # @param tag [String] 4 byte entry tag (semantic data type)
        # @param type [String] 4 byte entry data format
        # @param offset [String] 4 byte pointer to data in the index store
        # @param count [String] 4 byte number of data items held by the entry
        def initialize(tag, type, offset, count)
          @tag, @type, @offset, @count = tag, type, offset, count
        end

        attr_accessor :tag, :type, :offset, :count
      end
    end
  end
end
