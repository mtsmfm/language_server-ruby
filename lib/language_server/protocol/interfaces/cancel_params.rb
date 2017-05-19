module LanguageServer
  module Protocol
    module Interfaces
      class CancelParams
        def initialize(id:)
          @attributes = {}

          @attributes[:id] = id

          @attributes.freeze
        end

        #
        # The request id to cancel.
        #
        # @return [string | number]
        def id
          attributes.fetch(:id)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
