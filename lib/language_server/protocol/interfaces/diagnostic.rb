module LanguageServer
  module Protocol
    module Interfaces
      class Diagnostic
        def initialize(range:, severity: nil, code: nil, source: nil, message:)
          @attributes = {}

          @attributes[:range] = range
          @attributes[:severity] = severity if severity
          @attributes[:code] = code if code
          @attributes[:source] = source if source
          @attributes[:message] = message

          @attributes.freeze
        end

        #
        # The range at which the message applies.
        #
        # @return [Range]
        def range
          attributes.fetch(:range)
        end

        #
        # The diagnostic's severity. Can be omitted. If omitted it is up to the
        # client to interpret diagnostics as error, warning, info or hint.
        #
        # @return [number]
        def severity
          attributes.fetch(:severity)
        end

        #
        # The diagnostic's code. Can be omitted.
        #
        # @return [string | number]
        def code
          attributes.fetch(:code)
        end

        #
        # A human-readable string describing the source of this
        # diagnostic, e.g. 'typescript' or 'super lint'.
        #
        # @return [string]
        def source
          attributes.fetch(:source)
        end

        #
        # The diagnostic's message.
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
