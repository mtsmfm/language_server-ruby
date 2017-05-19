module LanguageServer
  module Protocol
    module Interfaces
      #
      # The parameters send in a will save text document notification.
      #
      class WillSaveTextDocumentParams
        def initialize(text_document:, reason:)
          @attributes = {}

          @attributes[:textDocument] = text_document
          @attributes[:reason] = reason

          @attributes.freeze
        end

        #
        # The document that will be saved.
        #
        # @return [TextDocumentIdentifier]
        def text_document
          attributes.fetch(:textDocument)
        end

        #
        # The 'TextDocumentSaveReason'.
        #
        # @return [number]
        def reason
          attributes.fetch(:reason)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
