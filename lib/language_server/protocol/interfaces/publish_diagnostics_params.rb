module LanguageServer
  module Protocol
    module Interfaces
      class PublishDiagnosticsParams
        def initialize(uri:, diagnostics:)
          @attributes = {}

          @attributes[:uri] = uri
          @attributes[:diagnostics] = diagnostics

          @attributes.freeze
        end

        #
        # The URI for which diagnostic information is reported.
        #
        # @return [string]
        def uri
          attributes.fetch(:uri)
        end

        #
        # An array of diagnostic information items.
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
