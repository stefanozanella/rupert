module Rupert
  class RPM
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

      attr_accessor :tag

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
      # * (+Array+ of) +String+ of length 1
      # * (+Array+ of) +Fixnum+
      # * (+Array+ of) +Fixnum+
      # * (+Array+ of) +Fixnum+
      # * (+Array+ of) +Fixnum+/+Bignum+
      # * +String+ of arbitrary length
      # * +String+ of arbitrary length, 8-bit ASCII encoded
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
        store.seek(@offset, IO::SEEK_SET)
        read_and_convert(@type, store)
      end

      private

      # :nodoc: Null byte used to indicate string termination
      NULL_CHAR = "\x00".force_encoding(Encoding::ASCII_8BIT)

      # :nodoc: Map of numerical entry types to parsing functions.
      #
      # NOTE: It turns out that distinguishing between strings and string
      # arrays is irrelevant (at least with this implementation), since for
      # every data type, if the count is 1 data is not wrapped in an array.
      TYPE_MAP = {
        4 => :int32,
        6 => :string,
        7 => :binary,
        8 => :string
      }

      # :nodoc: Reads given type of data from given store
      def read_and_convert(type, store)
        method(TYPE_MAP[type]).call(store)
      end

      # :nodoc: Returns a list of integers, or a single element if count is 1
      def int32(store)
        first_or(array_of(lambda { one_int_32(store) }))
      end

      # :nodoc: Returns an array with given number of null-terminated strings,
      # or a single string if count is 1
      def string(store)
        first_or(array_of(lambda { one_string(store) }))
      end

      def binary(store)
        store.read(@count)
      end

      # :nodoc: Parses a single int32 from the store
      def one_int_32(store)
        store.read(4).unpack("N").first
      end

      # :nodoc: Parses a null-terminated string, without the trailing null
      # character.
      def one_string(store)
        store.gets(NULL_CHAR).chomp(NULL_CHAR)
      end

      # :nodoc: Strips off array if it contains only one element
      def first_or(ary)
        ary.length == 1 ? ary.first : ary
      end

      # :nodoc: Builds an array of count elements parsed used given function
      def array_of(parse_fun)
        (1..@count).inject([]) { |ary|
          ary << parse_fun.call
        }
      end
    end
  end
end
