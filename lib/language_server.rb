require "language_server/version"
require "language_server/protocol/interfaces"
require "language_server/protocol/constants"
require "language_server/protocol/stdio"
require "language_server/linter/ruby_wc"
require "language_server/completion_provider/rcodetools"
require "language_server/file_store"

require "json"
require "logger"

module LanguageServer
  class << self
    def logger
      @logger ||= Logger.new(STDERR)
    end

    def run
      writer = Protocol::Stdio::Writer.new
      reader = Protocol::Stdio::Reader.new

      reader.read do |request|
        method = request[:method].to_sym

        logger.debug("Method: #{method} called")

        _, subscriber = subscribers.find {|k, _|
          k === method
        }

        if subscriber
          result = subscriber.call(request, writer.method(:notify))

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

  on :initialize do
    Protocol::Interfaces::InitializeResult.new(
      capabilities: Protocol::Interfaces::ServerCapabilities.new(
        text_document_sync: Protocol::Interfaces::TextDocumentSyncOptions.new(
          change: Protocol::Constants::TextDocumentSyncKind::FULL
        ),
        completion_provider: Protocol::Interfaces::CompletionOptions.new(
          resolve_provider: true,
          trigger_characters: %w(.)
        )
      )
    )
  end

  on :shutdown do
    exit
  end

  on :"textDocument/didChange" do |request, notifier|
    uri = request[:params][:textDocument][:uri]
    text = request[:params][:contentChanges][0][:text]
    FileStore[uri] = text

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

  on :"textDocument/completion" do |request|
    uri = request[:params][:textDocument][:uri]
    line, character = request[:params][:position].fetch_values(:line, :character)
    CompletionProvider::Rcodetools.new(uri, line.to_i, character.to_i).call.map do |candidate|
      Protocol::Interfaces::CompletionItem.new(
        label: candidate.method_name,
        detail: candidate.description,
        kind: Protocol::Constants::CompletionItemKind::METHOD
      )
    end
  end
end
