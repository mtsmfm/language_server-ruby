require "language_server/project"

module LanguageServer
  module CompletionProvider
    class AdHoc
      def initialize(uri:, line:, character:, project:)
        @uri = uri
        @line = line
        @character = character
        @project = project
      end

      def call
        (project.constants(uri: uri, line: line, character: character).map {|c|
          Protocol::Interfaces::CompletionItem.new(
            label: c.name,
            detail: c.full_name,
            documentation: "#{c.remote_path}##{c.lineno}",
            kind: Protocol::Constants::CompletionItemKind::ENUM
          )
        } +
        project.classes(uri: uri, line: line, character: character).map {|c|
          Protocol::Interfaces::CompletionItem.new(
            label: c.name,
            detail: c.full_name,
            documentation: "#{c.remote_path}##{c.lineno}",
            kind: Protocol::Constants::CompletionItemKind::CLASS
          )
        } +
        project.modules(uri: uri, line: line, character: character).map {|m|
          Protocol::Interfaces::CompletionItem.new(
            label: m.name,
            detail: m.full_name,
            documentation: "#{m.remote_path}##{m.lineno}",
            kind: Protocol::Constants::CompletionItemKind::MODULE
          )
        }).uniq(&:label)
      end

      private

      attr_reader :uri, :line, :character, :project
    end
  end
end
