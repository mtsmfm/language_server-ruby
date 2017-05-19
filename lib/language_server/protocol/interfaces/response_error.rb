module LanguageServer
  module Protocol
    module Interfaces
      class ResponseError
        def initialize(code:, message:, data: nil)
          @attributes = {}

          @attributes[:code] = code
          @attributes[:message] = message
          @attributes[:data] = data if data

          @attributes.freeze
        end

        #
        # A number indicating the error type that occurred.
        #
        # @return [number]
        def code
          attributes.fetch(:code)
        end

        #
        # A string providing a short description of the error.
        #
        # @return [string]
        def message
          attributes.fetch(:message)
        end

        #
        # A Primitive or Structured value that contains additional
        # information about the error. Can be omitted.
        #
        # @return [D]
        def data
          attributes.fetch(:data)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
