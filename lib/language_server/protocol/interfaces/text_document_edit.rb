module LanguageServer
  module Protocol
    module Interfaces
      class TextDocumentEdit
        def initialize(text_document:, edits:)
          @attributes = {}

          @attributes[:textDocument] = text_document
          @attributes[:edits] = edits

          @attributes.freeze
        end

        #
        # The text document to change.
        #
        # @return [VersionedTextDocumentIdentifier]
        def text_document
          attributes.fetch(:textDocument)
        end

        #
        # The edits to be applied.
        #
        # @return [TextEdit[]]
        def edits
          attributes.fetch(:edits)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
