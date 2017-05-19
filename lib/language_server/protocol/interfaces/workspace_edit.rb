module LanguageServer
  module Protocol
    module Interfaces
      class WorkspaceEdit
        def initialize(changes: nil, document_changes: nil)
          @attributes = {}

          @attributes[:changes] = changes if changes
          @attributes[:documentChanges] = document_changes if document_changes

          @attributes.freeze
        end

        #
        # Holds changes to existing resources.
        #
        # @return [{ [uri: string]: TextEdit[]; }]
        def changes
          attributes.fetch(:changes)
        end

        #
        # An array of `TextDocumentEdit`s to express changes to specific a specific
        # version of a text document. Whether a client supports versioned document
        # edits is expressed via `WorkspaceClientCapabilites.versionedWorkspaceEdit`.
        #
        # @return [TextDocumentEdit[]]
        def document_changes
          attributes.fetch(:documentChanges)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
