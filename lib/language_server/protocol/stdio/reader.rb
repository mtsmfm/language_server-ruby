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
    end
  end
end
