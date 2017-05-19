module LanguageServer
  module Protocol
    module Interfaces
      class TextDocumentItem
        def initialize(uri:, language_id:, version:, text:)
          @attributes = {}

          @attributes[:uri] = uri
          @attributes[:languageId] = language_id
          @attributes[:version] = version
          @attributes[:text] = text

          @attributes.freeze
        end

        #
        # The text document's URI.
        #
        # @return [string]
        def uri
          attributes.fetch(:uri)
        end

        #
        # The text document's language identifier.
        #
        # @return [string]
        def language_id
          attributes.fetch(:languageId)
        end

        #
        # The version number of this document (it will strictly increase after each
        # change, including undo/redo).
        #
        # @return [number]
        def version
          attributes.fetch(:version)
        end

        #
        # The content of the opened text document.
        #
        # @return [string]
        def text
          attributes.fetch(:text)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
