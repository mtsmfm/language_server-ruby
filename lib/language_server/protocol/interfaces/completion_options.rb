module LanguageServer
  module Protocol
    module Interfaces
      #
      # Completion options.
      #
      class CompletionOptions
        def initialize(resolve_provider: nil, trigger_characters: nil)
          @attributes = {}

          @attributes[:resolveProvider] = resolve_provider if resolve_provider
          @attributes[:triggerCharacters] = trigger_characters if trigger_characters

          @attributes.freeze
        end

        #
        # The server provides support to resolve additional
        # information for a completion item.
        #
        # @return [boolean]
        def resolve_provider
          attributes.fetch(:resolveProvider)
        end

        #
        # The characters that trigger completion automatically.
        #
        # @return [string[]]
        def trigger_characters
          attributes.fetch(:triggerCharacters)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
