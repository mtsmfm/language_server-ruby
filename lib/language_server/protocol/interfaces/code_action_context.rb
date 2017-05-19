module LanguageServer
  module Protocol
    module Interfaces
      #
      # Contains additional diagnostic information about the context in which
      # a code action is run.
      #
      class CodeActionContext
        def initialize(diagnostics:)
          @attributes = {}

          @attributes[:diagnostics] = diagnostics

          @attributes.freeze
        end

        #
        # An array of diagnostics.
        #
        # @return [Diagnostic[]]
        def diagnostics
          attributes.fetch(:diagnostics)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
