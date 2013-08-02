require 'rupert/rpm/signature/entry'
require 'rupert/rpm/signature/store'

module Rupert
  class RPM
    class Signature
      class Index
        # Initializes a new signature index, given the header's entries and the
        # store containing actual data.
        #
        # @param entries [Hash] a map of
        #                {Rupert::RPM::Signature::Entry}, indexed by tag
        # @param store [Rupert::RPM::Signature::Store] store containing
        #              data pointed by entries
        def initialize(entries, store)
          @entries = entries
          @store = store
        end

        # Retrieves data pointed by given tag.
        #
        # @param tag [Fixnum] data type
        # @return [Object] data associated to given tag, with variable format
        #         depending on how it's stored
        def get(tag)
          entry = @entries[tag]
          @store.fetch(entry)
        end
      end
    end
  end
end
