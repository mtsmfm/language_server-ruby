require "open3"

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
  end
end
