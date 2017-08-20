require "language_server/protocol/interfaces/completion_item"
require "language_server/protocol/constants/completion_item_kind"

require "rcodetools/completion"

module LanguageServer
  module CompletionProvider
    class Filter < ::Rcodetools::XMPCompletionFilter
      @candidates_with_description_flag = true

      def completion_code(*args)
        candidates_with_class(*args)
      rescue NewCodeError, RuntimeDataError, NoCandidates
        [nil, []]
      end
    end

    class Rcodetools
      def initialize(uri:, line:, character:, file_store:)
        @uri = uri
        @line = line
        @character = character
        @file_store = file_store
      end

      def call
        _, candidates = Filter.run(source, lineno: @line + 1, column: @character)
        candidates.map do |candidate|
          method_name, description = candidate.split(/\0/, 2)
          Protocol::Interfaces::CompletionItem.new(
            label: method_name,
            detail: description,
            kind: Protocol::Constants::CompletionItemKind::METHOD
          )
        end
      end

      private

      def source
        @file_store.read_remote_uri(@uri)
      end
    end
  end
end
