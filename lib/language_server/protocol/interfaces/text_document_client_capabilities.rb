module LanguageServer
  module Protocol
    module Interfaces
      #
      # Text document specific client capabilities.
      #
      class TextDocumentClientCapabilities
        def initialize(synchronization: nil, completion: nil, hover: nil, signature_help: nil, references: nil, document_highlight: nil, document_symbol: nil, formatting: nil, range_formatting: nil, on_type_formatting: nil, definition: nil, code_action: nil, code_lens: nil, document_link: nil, rename: nil)
          @attributes = {}

          @attributes[:synchronization] = synchronization if synchronization
          @attributes[:completion] = completion if completion
          @attributes[:hover] = hover if hover
          @attributes[:signatureHelp] = signature_help if signature_help
          @attributes[:references] = references if references
          @attributes[:documentHighlight] = document_highlight if document_highlight
          @attributes[:documentSymbol] = document_symbol if document_symbol
          @attributes[:formatting] = formatting if formatting
          @attributes[:rangeFormatting] = range_formatting if range_formatting
          @attributes[:onTypeFormatting] = on_type_formatting if on_type_formatting
          @attributes[:definition] = definition if definition
          @attributes[:codeAction] = code_action if code_action
          @attributes[:codeLens] = code_lens if code_lens
          @attributes[:documentLink] = document_link if document_link
          @attributes[:rename] = rename if rename

          @attributes.freeze
        end

        # @return [{ dynamicRegistration?: boolean; willSave?: boolean; willSaveWaitUntil?: boolean; didSave?: boole...]
        def synchronization
          attributes.fetch(:synchronization)
        end

        #
        # Capabilities specific to the `textDocument/completion`
        #
        # @return [{ dynamicRegistration?: boolean; completionItem?: { snippetSupport?: boolean; }; }]
        def completion
          attributes.fetch(:completion)
        end

        #
        # Capabilities specific to the `textDocument/hover`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def hover
          attributes.fetch(:hover)
        end

        #
        # Capabilities specific to the `textDocument/signatureHelp`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def signature_help
          attributes.fetch(:signatureHelp)
        end

        #
        # Capabilities specific to the `textDocument/references`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def references
          attributes.fetch(:references)
        end

        #
        # Capabilities specific to the `textDocument/documentHighlight`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def document_highlight
          attributes.fetch(:documentHighlight)
        end

        #
        # Capabilities specific to the `textDocument/documentSymbol`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def document_symbol
          attributes.fetch(:documentSymbol)
        end

        #
        # Capabilities specific to the `textDocument/formatting`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def formatting
          attributes.fetch(:formatting)
        end

        #
        # Capabilities specific to the `textDocument/rangeFormatting`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def range_formatting
          attributes.fetch(:rangeFormatting)
        end

        #
        # Capabilities specific to the `textDocument/onTypeFormatting`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def on_type_formatting
          attributes.fetch(:onTypeFormatting)
        end

        #
        # Capabilities specific to the `textDocument/definition`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def definition
          attributes.fetch(:definition)
        end

        #
        # Capabilities specific to the `textDocument/codeAction`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def code_action
          attributes.fetch(:codeAction)
        end

        #
        # Capabilities specific to the `textDocument/codeLens`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def code_lens
          attributes.fetch(:codeLens)
        end

        #
        # Capabilities specific to the `textDocument/documentLink`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def document_link
          attributes.fetch(:documentLink)
        end

        #
        # Capabilities specific to the `textDocument/rename`
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def rename
          attributes.fetch(:rename)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
