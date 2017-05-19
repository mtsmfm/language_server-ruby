module LanguageServer
  module Protocol
    module Interfaces
      #
      # The result of a hover request.
      #
      class Hover
        def initialize(contents:, range: nil)
          @attributes = {}

          @attributes[:contents] = contents
          @attributes[:range] = range if range

          @attributes.freeze
        end

        #
        # The hover's content
        #
        # @return [string | { language: string; value: string; } | MarkedString[]]
        def contents
          attributes.fetch(:contents)
        end

        #
        # An optional range is a range inside a text document
        # that is used to visualize a hover, e.g. by changing the background color.
        #
        # @return [Range]
        def range
          attributes.fetch(:range)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
