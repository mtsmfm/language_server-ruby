require "language_server/version"
require "language_server/protocol/interfaces"
require "language_server/protocol/constants"

require "json"
require "logger"
require "open3"
require "tempfile"
require "shellwords"

module LanguageServer
  module Protocol
    module Stdio
      class Reader
        def read(&block)
          buffer = ""
          header_parsed = false
          content_length = nil

          while char = STDIN.getc
            buffer << char

            unless header_parsed
              if buffer[-4..-1] == "\r\n" * 2
                content_length = buffer.match(/Content-Length: (\d+)/i)[1].to_i

                header_parsed = true
                buffer.clear
              end
            else
              if buffer.bytesize == content_length
                LanguageServer.logger.debug("Receive: #{buffer}")

                request = JSON.parse(buffer, symbolize_names: true)

                block.call(request)

                header_parsed = false
                buffer.clear
              end
            end
          end
        end
      end

      class Writer
        def respond(id:, result:)
          write(id: id, result: result)
        end

        def notify(method:, params: {})
          write(method: method, params: params)
        end

        private

        def write(response)
          response_str = response.merge(
            jsonrpc: "2.0"
          ).to_json

          headers = {
            "Content-Length" => response_str.bytesize
          }

          headers.each do |k, v|
            STDOUT.print "#{k}: #{v}\r\n"
          end

          STDOUT.print "\r\n"

          STDOUT.print response_str
          STDOUT.flush

          LanguageServer.logger.debug("Response: #{response_str}")
        end
      end
    end
  end

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

    diagnostics = nil

    Tempfile.create do |file|
      file.write(text)
      file.flush

      out, err, status = Open3.capture3("ruby -wc #{file.path.shellescape}")
      severity = status.success? ? Protocol::Constants::DiagnosticSeverity::WARNING : Protocol::Constants::DiagnosticSeverity::ERROR

      diagnostics = err.lines.map do |line|
        line_num, message = line.scan(/#{Regexp.escape(file.path)}:(\d+): (.*)\n/).flatten
        line_num = line_num.to_i

        Protocol::Interfaces::Diagnostic.new(
          message: message,
          severity: severity,
          range: Protocol::Interfaces::Range.new(
            start: Protocol::Interfaces::Position.new(
              line: line_num.to_i - 1,
              character: 0
            ),
            end: Protocol::Interfaces::Position.new(
              line: line_num.to_i - 1,
              character: 0
            )
          )
        )
      end
    end

    notifier.call(
      method: :"textDocument/publishDiagnostics",
      params: Protocol::Interfaces::PublishDiagnosticsParams.new(
        uri: uri,
        diagnostics: diagnostics
      )
    )
  end
end
