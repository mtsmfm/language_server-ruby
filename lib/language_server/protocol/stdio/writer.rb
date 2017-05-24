module LanguageServer
  module Protocol
    module Stdio
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
end
