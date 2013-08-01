require 'rupert/rpm/lead'
require 'rupert/rpm/signature'

module Rupert
  class Parser
    def initialize(raw_io)
      @raw_io = raw_io
    end

    def parse
      # TODO Fit to current design (i.e. no parsing in Lead c'tor?)
      lead = RPM::Lead.new(@raw_io)

      entry_count, store_size = parse_header
      entries = parse_entries(entry_count)

      store = parse_store(store_size)
      content = parse_content

      signature = RPM::Signature.new(RPM::Signature::Index.new(entries, store))

      RPM.new(lead, signature, content)
    end

    private

    def parse_header
      header_size = 16
      header_format =  "@8NN"

      @raw_io.read(header_size).unpack(header_format)
    end

    def parse_entries(count)
      entry_size = 16
      entry_format = "NNNN"

      entries = Hash.new
      count.times do
        tag, type, offset, count = @raw_io.read(entry_size).unpack(entry_format)
        entry = RPM::Signature::Entry.new tag, type, offset, count
        entries[entry.tag] = entry
      end

      entries
    end

    def parse_store(size)
      RPM::Signature::Store.new(StringIO.new(@raw_io.read(nearest_multiple(size, 8))))
    end

    def parse_content
      @raw_io.read
    end

    def nearest_multiple(size, modulo)
      (size / modulo.to_f).ceil * modulo
    end
  end
end
