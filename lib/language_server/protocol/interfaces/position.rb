module LanguageServer
  module Protocol
    module Interfaces
      class Position
        def initialize(line:, character:)
          @attributes = {}

          @attributes[:line] = line
          @attributes[:character] = character

          @attributes.freeze
        end

        #
        # Line position in a document (zero-based).
        #
        # @return [number]
        def line
          attributes.fetch(:line)
        end

        #
        # Character offset on a line in a document (zero-based).
        #
        # @return [number]
        def character
          attributes.fetch(:character)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
