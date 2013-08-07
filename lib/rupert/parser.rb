require 'rupert/rpm/lead'
require 'rupert/rpm/index'
require 'rupert/rpm/entry'

module Rupert
  class Parser
    def initialize(raw_io)
      @raw_io = raw_io
    end

    def parse
      # TODO Fit to current design (i.e. no parsing in Lead c'tor?)
      lead = RPM::Lead.new(@raw_io)

      signature = signature_from(parse_index(@raw_io))

      # TODO I'd like to get rid of this duplication, but still don't know how.
      # Ideally, raw signed content should be available from both archive and
      # header, and concatenated to calculate checksum.
      content = parse_content @raw_io
      @raw_io.seek(-content.length, IO::SEEK_CUR)

      header = header_from(parse_index(@raw_io))

      RPM.new(lead, signature, content, header)
    end

    private

    def header_from(index)
      RPM::Header.new index
    end

    def signature_from(index)
      RPM::Signature.new index
    end

    def parse_header(raw_io)
      header_size = 16
      header_format =  "@8NN"

      raw_io.read(header_size).unpack(header_format)
    end

    def parse_store(size, raw_io)
      StringIO.new(raw_io.read(nearest_multiple(8, size)))
    end

    def parse_content(raw_io)
      raw_io.read.force_encoding(Encoding::ASCII_8BIT)
    end

    def parse_index(raw_io)
      index = RPM::Index.new

      entry_count, store_size = parse_header(raw_io)
      entry_count.times do
        index.add parse_entry(raw_io)
      end

      index.store = parse_store(store_size, raw_io)

      index
    end

    def parse_entry(raw_io)
      entry_size = 16
      entry_format = "NNNN"

      RPM::Entry.new(*raw_io.read(entry_size).unpack(entry_format))
    end

    def nearest_multiple(modulo, size)
      (size / modulo.to_f).ceil * modulo
    end
  end
end
