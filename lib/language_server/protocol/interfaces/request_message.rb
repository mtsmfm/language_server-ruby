module LanguageServer
  module Protocol
    module Interfaces
      class RequestMessage
        def initialize(id:, method:, params: nil)
          @attributes = {}

          @attributes[:id] = id
          @attributes[:method] = method
          @attributes[:params] = params if params

          @attributes.freeze
        end

        #
        # The request id.
        #
        # @return [string | number]
        def id
          attributes.fetch(:id)
        end

        #
        # The method to be invoked.
        #
        # @return [string]
        def method
          attributes.fetch(:method)
        end

        #
        # The method's params.
        #
        # @return [any]
        def params
          attributes.fetch(:params)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
