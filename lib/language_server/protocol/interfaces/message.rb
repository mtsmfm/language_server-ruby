module LanguageServer
  module Protocol
    module Interfaces
      class Message
        def initialize(jsonrpc:)
          @attributes = {}

          @attributes[:jsonrpc] = jsonrpc

          @attributes.freeze
        end

        # @return [string]
        def jsonrpc
          attributes.fetch(:jsonrpc)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
