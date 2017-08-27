require "language_server/version"
require "language_server/logger"
require "language_server/protocol/interfaces"
require "language_server/protocol/constants"
require "language_server/protocol/stdio"
require "language_server/linter/ruby_wc"
require "language_server/completion_provider/rcodetools"
require "language_server/completion_provider/ad_hoc"
require "language_server/definition_provider/ad_hoc"
require "language_server/file_store"
require "language_server/project"

require "json"

module LanguageServer
  class << self
    def run
      writer = Protocol::Stdio::Writer.new
      reader = Protocol::Stdio::Reader.new
      variables = {}

      reader.read do |request|
        method = request[:method].to_sym

        logger.debug("Method: #{method} called")

        _, subscriber = subscribers.find {|k, _|
          k === method
        }

        if subscriber
          keys = subscriber.parameters.map(&:last)
          result = subscriber.call(
            {
              request: request, notifier: writer.method(:notify), variables: variables
            }.merge(variables).select {|k, _| keys.include?(k) }
          )

          if request[:id]
            writer.respond(id: request[:id], result: result)
          end
        else
          logger.debug("Ignore: #{method}")
        end
      end
    end

    def subscribers
      @subscribers ||= {}
    end

    def on(method, &callback)
      subscribers[method] = callback
    end
  end

  on :initialize do |request:, variables:|
    variables[:file_store] = FileStore.new(load_paths: $LOAD_PATH, remote_root: request[:params][:rootPath], local_root: Dir.getwd)
    variables[:project] = Project.new(variables[:file_store])

    Protocol::Interfaces::InitializeResult.new(
      capabilities: Protocol::Interfaces::ServerCapabilities.new(
        text_document_sync: Protocol::Interfaces::TextDocumentSyncOptions.new(
          change: Protocol::Constants::TextDocumentSyncKind::FULL
        ),
        completion_provider: Protocol::Interfaces::CompletionOptions.new(
          resolve_provider: true,
          trigger_characters: %w(.)
        ),
        definition_provider: true
      )
    )
  end

  on :shutdown do
    exit
  end

  on :"textDocument/didChange" do |request:, notifier:, file_store:, project:|
    uri = request[:params][:textDocument][:uri]
    text = request[:params][:contentChanges][0][:text]
    file_store.cache(uri, text)
    project.recalculate_result(uri)

    diagnostics = Linter::RubyWC.new(text).call.map do |error|
      Protocol::Interfaces::Diagnostic.new(
        message: error.message,
        severity: error.warning? ? Protocol::Constants::DiagnosticSeverity::WARNING : Protocol::Constants::DiagnosticSeverity::ERROR,
        range: Protocol::Interfaces::Range.new(
          start: Protocol::Interfaces::Position.new(
            line: error.line_num,
            character: 0
          ),
          end: Protocol::Interfaces::Position.new(
            line: error.line_num,
            character: 0
          )
        )
      )
    end

    notifier.call(
      method: :"textDocument/publishDiagnostics",
      params: Protocol::Interfaces::PublishDiagnosticsParams.new(
        uri: uri,
        diagnostics: diagnostics
      )
    )
  end

  on :"textDocument/completion" do |request:, file_store:, project:|
    uri = request[:params][:textDocument][:uri]
    line, character = request[:params][:position].fetch_values(:line, :character).map(&:to_i)

    [
      CompletionProvider::AdHoc.new(uri: uri, line: line, character: character, project: project),
      CompletionProvider::Rcodetools.new(uri: uri, line: line, character: character, file_store: file_store)
    ].flat_map(&:call)
  end

  on :"textDocument/definition" do |request:, project:|
    uri = request[:params][:textDocument][:uri]
    line, character = request[:params][:position].fetch_values(:line, :character).map(&:to_i)

    [
      DefinitionProvider::AdHoc.new(uri: uri, line: line, character: character, project: project),
    ].flat_map(&:call)
  end
end
