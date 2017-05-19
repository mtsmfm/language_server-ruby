module LanguageServer
  module Protocol
    module Interfaces
      class ServerCapabilities
        def initialize(text_document_sync: nil, hover_provider: nil, completion_provider: nil, signature_help_provider: nil, definition_provider: nil, references_provider: nil, document_highlight_provider: nil, document_symbol_provider: nil, workspace_symbol_provider: nil, code_action_provider: nil, code_lens_provider: nil, document_formatting_provider: nil, document_range_formatting_provider: nil, document_on_type_formatting_provider: nil, rename_provider: nil, document_link_provider: nil, execute_command_provider: nil, experimental: nil)
          @attributes = {}

          @attributes[:textDocumentSync] = text_document_sync if text_document_sync
          @attributes[:hoverProvider] = hover_provider if hover_provider
          @attributes[:completionProvider] = completion_provider if completion_provider
          @attributes[:signatureHelpProvider] = signature_help_provider if signature_help_provider
          @attributes[:definitionProvider] = definition_provider if definition_provider
          @attributes[:referencesProvider] = references_provider if references_provider
          @attributes[:documentHighlightProvider] = document_highlight_provider if document_highlight_provider
          @attributes[:documentSymbolProvider] = document_symbol_provider if document_symbol_provider
          @attributes[:workspaceSymbolProvider] = workspace_symbol_provider if workspace_symbol_provider
          @attributes[:codeActionProvider] = code_action_provider if code_action_provider
          @attributes[:codeLensProvider] = code_lens_provider if code_lens_provider
          @attributes[:documentFormattingProvider] = document_formatting_provider if document_formatting_provider
          @attributes[:documentRangeFormattingProvider] = document_range_formatting_provider if document_range_formatting_provider
          @attributes[:documentOnTypeFormattingProvider] = document_on_type_formatting_provider if document_on_type_formatting_provider
          @attributes[:renameProvider] = rename_provider if rename_provider
          @attributes[:documentLinkProvider] = document_link_provider if document_link_provider
          @attributes[:executeCommandProvider] = execute_command_provider if execute_command_provider
          @attributes[:experimental] = experimental if experimental

          @attributes.freeze
        end

        #
        # Defines how text documents are synced. Is either a detailed structure defining each notification or
        # for backwards compatibility the TextDocumentSyncKind number.
        #
        # @return [number | TextDocumentSyncOptions]
        def text_document_sync
          attributes.fetch(:textDocumentSync)
        end

        #
        # The server provides hover support.
        #
        # @return [boolean]
        def hover_provider
          attributes.fetch(:hoverProvider)
        end

        #
        # The server provides completion support.
        #
        # @return [CompletionOptions]
        def completion_provider
          attributes.fetch(:completionProvider)
        end

        #
        # The server provides signature help support.
        #
        # @return [SignatureHelpOptions]
        def signature_help_provider
          attributes.fetch(:signatureHelpProvider)
        end

        #
        # The server provides goto definition support.
        #
        # @return [boolean]
        def definition_provider
          attributes.fetch(:definitionProvider)
        end

        #
        # The server provides find references support.
        #
        # @return [boolean]
        def references_provider
          attributes.fetch(:referencesProvider)
        end

        #
        # The server provides document highlight support.
        #
        # @return [boolean]
        def document_highlight_provider
          attributes.fetch(:documentHighlightProvider)
        end

        #
        # The server provides document symbol support.
        #
        # @return [boolean]
        def document_symbol_provider
          attributes.fetch(:documentSymbolProvider)
        end

        #
        # The server provides workspace symbol support.
        #
        # @return [boolean]
        def workspace_symbol_provider
          attributes.fetch(:workspaceSymbolProvider)
        end

        #
        # The server provides code actions.
        #
        # @return [boolean]
        def code_action_provider
          attributes.fetch(:codeActionProvider)
        end

        #
        # The server provides code lens.
        #
        # @return [CodeLensOptions]
        def code_lens_provider
          attributes.fetch(:codeLensProvider)
        end

        #
        # The server provides document formatting.
        #
        # @return [boolean]
        def document_formatting_provider
          attributes.fetch(:documentFormattingProvider)
        end

        #
        # The server provides document range formatting.
        #
        # @return [boolean]
        def document_range_formatting_provider
          attributes.fetch(:documentRangeFormattingProvider)
        end

        #
        # The server provides document formatting on typing.
        #
        # @return [DocumentOnTypeFormattingOptions]
        def document_on_type_formatting_provider
          attributes.fetch(:documentOnTypeFormattingProvider)
        end

        #
        # The server provides rename support.
        #
        # @return [boolean]
        def rename_provider
          attributes.fetch(:renameProvider)
        end

        #
        # The server provides document link support.
        #
        # @return [DocumentLinkOptions]
        def document_link_provider
          attributes.fetch(:documentLinkProvider)
        end

        #
        # The server provides execute command support.
        #
        # @return [ExecuteCommandOptions]
        def execute_command_provider
          attributes.fetch(:executeCommandProvider)
        end

        #
        # Experimental server capabilities.
        #
        # @return [any]
        def experimental
          attributes.fetch(:experimental)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
