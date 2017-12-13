require "language_server/version"
require "language_server/logger"
require "language_server/protocol"
require "language_server/linter/ruby_wc"
require "language_server/linter/rubocop"
require "language_server/completion_provider/ad_hoc"
require "language_server/definition_provider/ad_hoc"
require "language_server/file_store"
require "language_server/project"

require "json"

module LanguageServer
  class << self
    attr_accessor :options

    def run(options)
      self.options = options

      writer = Protocol::Transport::Stdio::Writer.new
      reader = Protocol::Transport::Stdio::Reader.new
      variables = {}

      class << writer
        def respond(id:, result:)
          write(id: id, result: result)

          LanguageServer.logger.debug("Respond: id: #{id}, result: #{JSON.pretty_generate(result)}")
        end

        def notify(method:, params: {})
          write(method: method, params: params)

          LanguageServer.logger.debug("Notify: method: #{method}, params: #{JSON.pretty_generate(params)}")
        end
      end

      reader.read do |request|
        logger.debug("Receive: #{JSON.pretty_generate(request)}")

        method = request[:method].to_sym

        subscriber = subscribers[method]

        if subscriber
          keys = subscriber.parameters.map(&:last)
          result = subscriber.call(
            {
              request: request, notifier: writer.method(:notify), variables: variables
            }.merge(variables).select { |k, _| keys.include?(k) },
          )

          if request[:id]
            writer.respond(id: request[:id], result: result)
          end
        else
          logger.debug("Ignore: #{method}")
        end
      end
    end

    def rubocop_enabled?
      options[:experimental_features_enabled]
    end

    def adhoc_enabled?
      options[:experimental_features_enabled]
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
    variables[:project] =
      if LanguageServer.adhoc_enabled?
        variables[:project] = Project.new(variables[:file_store])
      end

    Protocol::Interface::InitializeResult.new(
      capabilities: Protocol::Interface::ServerCapabilities.new(
        text_document_sync: Protocol::Interface::TextDocumentSyncOptions.new(
          change: Protocol::Constant::TextDocumentSyncKind::FULL,
        ),
        completion_provider: if LanguageServer.adhoc_enabled?
                               Protocol::Interface::CompletionOptions.new(
                                 resolve_provider: true,
                                 trigger_characters: %w[.],
                               )
                             else
                               false
                             end,
        definition_provider: LanguageServer.adhoc_enabled?,
      ),
    )
  end

  on :shutdown do
    exit
  end

  on :"textDocument/didChange" do |request:, notifier:, file_store:, project:|
    uri = request[:params][:textDocument][:uri]
    text = request[:params][:contentChanges][0][:text]
    file_store.cache(uri, text)
    project.recalculate_result(uri) if LanguageServer.adhoc_enabled?

    diagnostics = Linter::RubyWC.new(text).call
    diagnostics += Linter::Rubocop.new(text).call if LanguageServer.rubocop_enabled?

    diagnostics = diagnostics.map do |error|
      Protocol::Interface::Diagnostic.new(
        message: error.message,
        severity: error.warning? ? Protocol::Constant::DiagnosticSeverity::WARNING : Protocol::Constant::DiagnosticSeverity::ERROR,
        range: Protocol::Interface::Range.new(
          start: Protocol::Interface::Position.new(
            line: error.line_num,
            character: error.characters.min,
          ),
          end: Protocol::Interface::Position.new(
            line: error.line_num,
            character: error.characters.max,
          ),
        ),
      )
    end

    notifier.call(
      method: :"textDocument/publishDiagnostics",
      params: Protocol::Interface::PublishDiagnosticsParams.new(
        uri: uri,
        diagnostics: diagnostics,
      ),
    )
  end

  on :"textDocument/completion" do |request:, project:|
    uri = request[:params][:textDocument][:uri]
    line, character = request[:params][:position].fetch_values(:line, :character).map(&:to_i)

    if LanguageServer.adhoc_enabled?
      [
        CompletionProvider::AdHoc.new(uri: uri, line: line, character: character, project: project),
      ].flat_map(&:call)
    end
  end

  on :"textDocument/definition" do |request:, project:|
    uri = request[:params][:textDocument][:uri]
    line, character = request[:params][:position].fetch_values(:line, :character).map(&:to_i)

    if LanguageServer.adhoc_enabled?
      [
        DefinitionProvider::AdHoc.new(uri: uri, line: line, character: character, project: project),
      ].flat_map(&:call)
    end
  end
end
