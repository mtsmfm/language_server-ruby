module LanguageServer
  module Protocol
    module Interfaces
      #
      # The parameters of a Workspace Symbol Request.
      #
      class WorkspaceSymbolParams
        def initialize(query:)
          @attributes = {}

          @attributes[:query] = query

          @attributes.freeze
        end

        #
        # A non-empty query string
        #
        # @return [string]
        def query
          attributes.fetch(:query)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
