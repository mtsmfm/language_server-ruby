module LanguageServer
  module Protocol
    module Interfaces
      class NotificationMessage
        def initialize(method:, params: nil)
          @attributes = {}

          @attributes[:method] = method
          @attributes[:params] = params if params

          @attributes.freeze
        end

        #
        # The method to be invoked.
        #
        # @return [string]
        def method
          attributes.fetch(:method)
        end

        #
        # The notification's params.
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
