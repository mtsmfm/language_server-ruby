module LanguageServer
  module Protocol
    module Interfaces
      class TextDocumentRegistrationOptions
        def initialize(document_selector:)
          @attributes = {}

          @attributes[:documentSelector] = document_selector

          @attributes.freeze
        end

        #
        # A document selector to identify the scope of the registration. If set to null
        # the document selector provided on the client side will be used.
        #
        # @return [DocumentFilter[]]
        def document_selector
          attributes.fetch(:documentSelector)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
