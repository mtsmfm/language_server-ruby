module LanguageServer
  module Protocol
    module Interfaces
      class TextDocumentPositionParams
        def initialize(text_document:, position:)
          @attributes = {}

          @attributes[:textDocument] = text_document
          @attributes[:position] = position

          @attributes.freeze
        end

        #
        # The text document.
        #
        # @return [TextDocumentIdentifier]
        def text_document
          attributes.fetch(:textDocument)
        end

        #
        # The position inside the text document.
        #
        # @return [Position]
        def position
          attributes.fetch(:position)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
