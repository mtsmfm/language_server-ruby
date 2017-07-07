require "language_server/file_store"

require "rcodetools/completion"

module LanguageServer
  module CompletionProvider
    class Candidate
      attr_reader :method_name, :description

      def initialize(method_name:, description:)
        @method_name = method_name
        @description = description
      end

      def ==(other)
        method_name == other.method_name && description == other.description
      end
    end

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
          Candidate.new(method_name: method_name, description: description)
        end
      end

      private

      def source
        @file_store.read(@uri)
      end
    end
  end
end
