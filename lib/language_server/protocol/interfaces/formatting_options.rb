module LanguageServer
  module Protocol
    module Interfaces
      #
      # Value-object describing what options formatting should use.
      #
      class FormattingOptions
        def initialize(tab_size:, insert_spaces:)
          @attributes = {}

          @attributes[:tabSize] = tab_size
          @attributes[:insertSpaces] = insert_spaces

          @attributes.freeze
        end

        #
        # Size of a tab in spaces.
        #
        # @return [number]
        def tab_size
          attributes.fetch(:tabSize)
        end

        #
        # Prefer spaces over tabs.
        #
        # @return [boolean]
        def insert_spaces
          attributes.fetch(:insertSpaces)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
