require "language_server/project"

module LanguageServer
  module CompletionProvider
    class AdHoc
      def initialize(uri:, line:, character:, file_store:)
        @uri = uri
        @line = line
        @character = character
        @file_store = file_store
      end

      def call
        project.constants
      end

      private

      def project
        @project ||= Project.new(@file_store)
      end
    end
  end
end
