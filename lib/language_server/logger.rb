require "logger"

module LanguageServer
  class << self
    def logger
      @logger ||= ::Logger.new(STDERR, formatter: Formatter.new)
    end
  end

  class Formatter
    RESET = "\e[0m".freeze
    RED = "\e[31m".freeze
    YELLOW = "\e[33m".freeze

    def call(severity, *rest)
      msg = default_message(severity, *rest)
      case severity
      when "ERROR"
        RED + msg + RESET
      when "WARN"
        YELLOW + msg + RESET
      else
        msg
      end
    end

    private

      def default_message(*args)
        default_formatter.call(*args)
      end

      def default_formatter
        @default_formatter ||= ::Logger::Formatter.new
      end
  end
end
