module LanguageServer
  module Protocol
    module Interfaces
      class RenameParams
        def initialize(text_document:, position:, new_name:)
          @attributes = {}

          @attributes[:textDocument] = text_document
          @attributes[:position] = position
          @attributes[:newName] = new_name

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
        # The position at which this request was sent.
        #
        # @return [Position]
        def position
          attributes.fetch(:position)
        end

        #
        # The new name of the symbol. If the given name is not valid the
        # request must return a [ResponseError](#ResponseError) with an
        # appropriate message set.
        #
        # @return [string]
        def new_name
          attributes.fetch(:newName)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
