module LanguageServer
  module Protocol
    module Interfaces
      class Range
        def initialize(start:, end:)
          @attributes = {}

          @attributes[:start] = start
          @attributes[:end] = binding.local_variable_get(:end)

          @attributes.freeze
        end

        #
        # The range's start position.
        #
        # @return [Position]
        def start
          attributes.fetch(:start)
        end

        #
        # The range's end position.
        #
        # @return [Position]
        def end
          attributes.fetch(:end)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
