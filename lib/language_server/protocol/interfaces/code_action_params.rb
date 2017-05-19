module LanguageServer
  module Protocol
    module Interfaces
      #
      # Params for the CodeActionRequest
      #
      class CodeActionParams
        def initialize(text_document:, range:, context:)
          @attributes = {}

          @attributes[:textDocument] = text_document
          @attributes[:range] = range
          @attributes[:context] = context

          @attributes.freeze
        end

        #
        # The document in which the command was invoked.
        #
        # @return [TextDocumentIdentifier]
        def text_document
          attributes.fetch(:textDocument)
        end

        #
        # The range for which the command was invoked.
        #
        # @return [Range]
        def range
          attributes.fetch(:range)
        end

        #
        # Context carrying additional information.
        #
        # @return [CodeActionContext]
        def context
          attributes.fetch(:context)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
