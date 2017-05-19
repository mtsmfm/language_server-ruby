module LanguageServer
  module Protocol
    module Interfaces
      class ApplyWorkspaceEditResponse
        def initialize(applied:)
          @attributes = {}

          @attributes[:applied] = applied

          @attributes.freeze
        end

        #
        # Indicates whether the edit was applied or not.
        #
        # @return [boolean]
        def applied
          attributes.fetch(:applied)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
