module LanguageServer
  module Protocol
    module Interfaces
      class CompletionItem
        def initialize(label:, kind: nil, detail: nil, documentation: nil, sort_text: nil, filter_text: nil, insert_text: nil, insert_text_format: nil, text_edit: nil, additional_text_edits: nil, command: nil, data: nil)
          @attributes = {}

          @attributes[:label] = label
          @attributes[:kind] = kind if kind
          @attributes[:detail] = detail if detail
          @attributes[:documentation] = documentation if documentation
          @attributes[:sortText] = sort_text if sort_text
          @attributes[:filterText] = filter_text if filter_text
          @attributes[:insertText] = insert_text if insert_text
          @attributes[:insertTextFormat] = insert_text_format if insert_text_format
          @attributes[:textEdit] = text_edit if text_edit
          @attributes[:additionalTextEdits] = additional_text_edits if additional_text_edits
          @attributes[:command] = command if command
          @attributes[:data] = data if data

          @attributes.freeze
        end

        #
        # The label of this completion item. By default
        # also the text that is inserted when selecting
        # this completion.
        #
        # @return [string]
        def label
          attributes.fetch(:label)
        end

        #
        # The kind of this completion item. Based of the kind
        # an icon is chosen by the editor.
        #
        # @return [number]
        def kind
          attributes.fetch(:kind)
        end

        #
        # A human-readable string with additional information
        # about this item, like type or symbol information.
        #
        # @return [string]
        def detail
          attributes.fetch(:detail)
        end

        #
        # A human-readable string that represents a doc-comment.
        #
        # @return [string]
        def documentation
          attributes.fetch(:documentation)
        end

        #
        # A string that shoud be used when comparing this item
        # with other items. When `falsy` the label is used.
        #
        # @return [string]
        def sort_text
          attributes.fetch(:sortText)
        end

        #
        # A string that should be used when filtering a set of
        # completion items. When `falsy` the label is used.
        #
        # @return [string]
        def filter_text
          attributes.fetch(:filterText)
        end

        #
        # A string that should be inserted a document when selecting
        # this completion. When `falsy` the label is used.
        #
        # @return [string]
        def insert_text
          attributes.fetch(:insertText)
        end

        #
        # The format of the insert text. The format applies to both the `insertText` property
        # and the `newText` property of a provided `textEdit`.
        #
        # @return [InsertTextFormat]
        def insert_text_format
          attributes.fetch(:insertTextFormat)
        end

        #
        # An edit which is applied to a document when selecting this completion. When an edit is provided the value of
        # `insertText` is ignored.
        #
        # *Note:* The range of the edit must be a single line range and it must contain the position at which completion
        # has been requested.
        #
        # @return [TextEdit]
        def text_edit
          attributes.fetch(:textEdit)
        end

        #
        # An optional array of additional text edits that are applied when
        # selecting this completion. Edits must not overlap with the main edit
        # nor with themselves.
        #
        # @return [TextEdit[]]
        def additional_text_edits
          attributes.fetch(:additionalTextEdits)
        end

        #
        # An optional command that is executed *after* inserting this completion. *Note* that
        # additional modifications to the current document should be described with the
        # additionalTextEdits-property.
        #
        # @return [Command]
        def command
          attributes.fetch(:command)
        end

        #
        # An data entry field that is preserved on a completion item between
        # a completion and a completion resolve request.
        #
        # @return [any]
        def data
          attributes.fetch(:data)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
