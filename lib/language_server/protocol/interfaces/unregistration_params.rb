module LanguageServer
  module Protocol
    module Interfaces
      class UnregistrationParams
        def initialize(unregisterations:)
          @attributes = {}

          @attributes[:unregisterations] = unregisterations

          @attributes.freeze
        end

        # @return [Unregistration[]]
        def unregisterations
          attributes.fetch(:unregisterations)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
