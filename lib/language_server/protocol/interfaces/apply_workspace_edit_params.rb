module LanguageServer
  module Protocol
    module Interfaces
      class ApplyWorkspaceEditParams
        def initialize(edit:)
          @attributes = {}

          @attributes[:edit] = edit

          @attributes.freeze
        end

        #
        # The edits to apply.
        #
        # @return [WorkspaceEdit]
        def edit
          attributes.fetch(:edit)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
