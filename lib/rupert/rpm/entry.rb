module Rupert
  class RPM
    class Entry
      STRING_TYPE = 6.freeze
      BIN_TYPE = 7.freeze

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

      # Fetches referenced data from a store.
      #
      # An entry contains only information about a piece of data, but not the
      # actual data. In essence, it behaves more or less like a pointer,
      # which contains the address at which data is available.
      #
      # This method behaves exactly like pointer dereference, i.e. it returns
      # the actual data at the address held by the entry itself. In addition,
      # data is not returned in raw form; instead, it is returned in the
      # format declared in the entry itself. The available RPM formats are the
      # following:
      #
      # * NULL
      # * CHAR
      # * INT8
      # * INT16
      # * INT32
      # * INT64 (not supported yet even in rpmlib?)
      # * STRING
      # * BIN
      # * STRING_ARRAY
      # * I18NSTRING
      #
      # which are in turn mapped in Ruby with:
      #
      # * +nil+
      # * +String+ of length 1
      # * +Fixnum+
      # * +Fixnum+
      # * +Fixnum+
      # * +Fixnum+/+Bignum+
      # * +String+ of arbitrary length
      # * +String+ of aribtrary length, 8-bit ASCII encoded
      # * +Array+ of +String+
      # * +Array+ of +String+
      #
      # *NOTE*: The store is sought to retrieve data. Do not make any
      # assumptions on IO's pointer state after method call. If you need to
      # perform subsequent operations on the IO that require a particular
      # cursor position, seek the IO to wanted position before performing
      # the operation.
      #
      # @param store [IO] raw data store, represented by an IO object
      # @return [Object] data referenced by this entry, in whatever format
      #         the entry prescribe
      def resolve(store)
        store.seek(offset, IO::SEEK_SET)

        case type
        when BIN_TYPE
          binary_from store
        when STRING_TYPE
          string_from store
        end
      end

      private

      # :nodoc: Null byte used to indicate string termination
      NULL_CHAR = "\x00".force_encoding(Encoding::ASCII_8BIT)

      def binary_from(store)
        store.read(count)
      end

      # :nodoc: Returns a null-terminated string, without the trailing null
      # character.
      def string_from(store)
        store.gets(NULL_CHAR).chomp(NULL_CHAR)
      end
    end
  end
end