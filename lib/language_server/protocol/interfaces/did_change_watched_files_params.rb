module LanguageServer
  module Protocol
    module Interfaces
      class DidChangeWatchedFilesParams
        def initialize(changes:)
          @attributes = {}

          @attributes[:changes] = changes

          @attributes.freeze
        end

        #
        # The actual file events.
        #
        # @return [FileEvent[]]
        def changes
          attributes.fetch(:changes)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
