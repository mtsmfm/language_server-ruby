require "open3"
require "tempfile"
require "shellwords"

module LanguageServer
  module Linter
    class Error
      attr_reader :line_num, :message, :type

      def initialize(line_num:, message:, type:)
        @line_num = line_num
        @message = message
        @type = type
      end

      def warning?
        @type == "warning"
      end

      def ==(other)
        line_num == other.line_num && message == other.message
      end
    end

    class RubyWC
      def initialize(source)
        @source = source
      end

      def call
        Tempfile.create do |file|
          file.write(@source)
          file.flush

          path = file.path.shellescape

          _, err, _ = Open3.capture3("ruby -wc #{path}")

          err.scan(/.+:(\d+):\s*(.+?)[,:]\s(.+)/).map do |line_num, type,  message|
            Error.new(line_num: line_num.to_i, message: message, type: type)
          end
        end
      end
    end
  end
end
