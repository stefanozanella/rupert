require 'rupert/rpm/entry'

module Rupert
  class RPM
    class Index
      attr_writer :store

      # Initializes a new signature index, given the header's entries and the
      # store containing actual data.
      #
      # @param entries [Array] a list of
      #                {Rupert::RPM::Entry}, or optionally a
      #                single {Rupert::RPM::Entry} not included in
      #                any array
      # @param store [IO] raw store containing data pointed by entries
      def initialize(entries=[], store=nil)
        @entries = index list_of entries
        @store = store
      end

      # Retrieves data pointed by given tag.
      #
      # @param tag [Fixnum] data type
      # @return [Object] data associated to given tag, with variable format
      #         depending on how it's stored (see
      #         {Rupert::RPM::Entry#resolve})
      def get(tag)
        @entries[tag].resolve(@store)
      end

      # Adds an entry to the index.
      #
      # @param entry [Rupert::RPM::Entry] new entry to add to the index
      def add(entry)
        @entries[entry.tag] = entry
      end

      private

      # :nodoc: Force returned object to be an array
      def list_of(maybe_an_array)
        [maybe_an_array].flatten
      end

      # :nodoc: Given an array of entries, index them by tag
      def index(entries)
        Hash[entries.collect { |entry| [entry.tag, entry] }]
      end
    end
  end
end
