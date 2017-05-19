module LanguageServer
  module Protocol
    module Interfaces
      class VersionedTextDocumentIdentifier
        def initialize(version:)
          @attributes = {}

          @attributes[:version] = version

          @attributes.freeze
        end

        #
        # The version number of this document.
        #
        # @return [number]
        def version
          attributes.fetch(:version)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
