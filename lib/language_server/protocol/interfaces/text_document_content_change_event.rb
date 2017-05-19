module LanguageServer
  module Protocol
    module Interfaces
      #
      # An event describing a change to a text document. If range and rangeLength are omitted
      # the new text is considered to be the full content of the document.
      #
      class TextDocumentContentChangeEvent
        def initialize(range: nil, range_length: nil, text:)
          @attributes = {}

          @attributes[:range] = range if range
          @attributes[:rangeLength] = range_length if range_length
          @attributes[:text] = text

          @attributes.freeze
        end

        #
        # The range of the document that changed.
        #
        # @return [Range]
        def range
          attributes.fetch(:range)
        end

        #
        # The length of the range that got replaced.
        #
        # @return [number]
        def range_length
          attributes.fetch(:rangeLength)
        end

        #
        # The new text of the range/document.
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
