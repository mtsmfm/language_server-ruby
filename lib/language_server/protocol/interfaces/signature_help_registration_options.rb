module LanguageServer
  module Protocol
    module Interfaces
      class SignatureHelpRegistrationOptions
        def initialize(trigger_characters: nil)
          @attributes = {}

          @attributes[:triggerCharacters] = trigger_characters if trigger_characters

          @attributes.freeze
        end

        #
        # The characters that trigger signature help
        # automatically.
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
