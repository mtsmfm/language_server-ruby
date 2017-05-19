module LanguageServer
  module Protocol
    module Interfaces
      class ShowMessageParams
        def initialize(type:, message:)
          @attributes = {}

          @attributes[:type] = type
          @attributes[:message] = message

          @attributes.freeze
        end

        #
        # The message type. See {@link MessageType}.
        #
        # @return [number]
        def type
          attributes.fetch(:type)
        end

        #
        # The actual message.
        #
        # @return [string]
        def message
          attributes.fetch(:message)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
