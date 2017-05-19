module LanguageServer
  module Protocol
    module Interfaces
      #
      # Represents a collection of [completion items](#CompletionItem) to be presented
      # in the editor.
      #
      class CompletionList
        def initialize(is_incomplete:, items:)
          @attributes = {}

          @attributes[:isIncomplete] = is_incomplete
          @attributes[:items] = items

          @attributes.freeze
        end

        #
        # This list it not complete. Further typing should result in recomputing
        # this list.
        #
        # @return [boolean]
        def is_incomplete
          attributes.fetch(:isIncomplete)
        end

        #
        # The completion items.
        #
        # @return [CompletionItem[]]
        def items
          attributes.fetch(:items)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
