module LanguageServer
  module Protocol
    module Interfaces
      #
      # A document highlight is a range inside a text document which deserves
      # special attention. Usually a document highlight is visualized by changing
      # the background color of its range.
      #
      class DocumentHighlight
        def initialize(range:, kind: nil)
          @attributes = {}

          @attributes[:range] = range
          @attributes[:kind] = kind if kind

          @attributes.freeze
        end

        #
        # The range this highlight applies to.
        #
        # @return [Range]
        def range
          attributes.fetch(:range)
        end

        #
        # The highlight kind, default is DocumentHighlightKind.Text.
        #
        # @return [number]
        def kind
          attributes.fetch(:kind)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
