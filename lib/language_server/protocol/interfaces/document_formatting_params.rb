module LanguageServer
  module Protocol
    module Interfaces
      class DocumentFormattingParams
        def initialize(text_document:, options:)
          @attributes = {}

          @attributes[:textDocument] = text_document
          @attributes[:options] = options

          @attributes.freeze
        end

        #
        # The document to format.
        #
        # @return [TextDocumentIdentifier]
        def text_document
          attributes.fetch(:textDocument)
        end

        #
        # The format options.
        #
        # @return [FormattingOptions]
        def options
          attributes.fetch(:options)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
