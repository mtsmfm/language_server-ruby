module LanguageServer
  module Protocol
    module Interfaces
      class ReferenceParams
        def initialize(context:)
          @attributes = {}

          @attributes[:context] = context

          @attributes.freeze
        end

        # @return [ReferenceContext]
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
