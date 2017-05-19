module LanguageServer
  module Protocol
    module Interfaces
      class ReferenceContext
        def initialize(include_declaration:)
          @attributes = {}

          @attributes[:includeDeclaration] = include_declaration

          @attributes.freeze
        end

        #
        # Include the declaration of the current symbol.
        #
        # @return [boolean]
        def include_declaration
          attributes.fetch(:includeDeclaration)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
