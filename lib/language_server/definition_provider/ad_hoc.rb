module LanguageServer
  module DefinitionProvider
    class AdHoc
      def initialize(uri:, line:, character:, project:)
        @uri = uri
        @line = line
        @character = character
        @project = project
      end

      def call
        project.find_definitions(uri: uri, line: line, character: character).map do |n|
          Protocol::Interfaces::Location.new(
            uri: "file://#{n.remote_path}",
            range: Protocol::Interfaces::Range.new(
              start: Protocol::Interfaces::Position.new(
                line: n.lines.begin,
                character: 0
              ),
              end: Protocol::Interfaces::Position.new(
                line: n.lines.end,
                character: 0
              )
            )
          )
        end
      end

      private

      attr_reader :uri, :line, :character, :project
    end
  end
end
