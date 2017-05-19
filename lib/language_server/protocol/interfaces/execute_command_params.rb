module LanguageServer
  module Protocol
    module Interfaces
      class ExecuteCommandParams
        def initialize(command:, arguments: nil)
          @attributes = {}

          @attributes[:command] = command
          @attributes[:arguments] = arguments if arguments

          @attributes.freeze
        end

        #
        # The identifier of the actual command handler.
        #
        # @return [string]
        def command
          attributes.fetch(:command)
        end

        #
        # Arguments that the command should be invoked with.
        #
        # @return [any[]]
        def arguments
          attributes.fetch(:arguments)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
