module LanguageServer
  module Protocol
    module Interfaces
      class DidChangeConfigurationParams
        def initialize(settings:)
          @attributes = {}

          @attributes[:settings] = settings

          @attributes.freeze
        end

        #
        # The actual changed settings
        #
        # @return [any]
        def settings
          attributes.fetch(:settings)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
