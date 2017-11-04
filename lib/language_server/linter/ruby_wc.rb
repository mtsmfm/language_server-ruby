require "stringio"

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
        error_message.scan(/.+:(\d+):\s*(.+?)[,:]\s(.+)/).map do |line_num, type, message|
          Error.new(line_num: line_num.to_i - 1, message: message, type: type)
        end
      end

      private

        # Since Ruby 2.4, syntax error information is outputted to Exception#message instead of stderr
        if begin; stderr = $stderr; $stderr = StringIO.new; RubyVM::InstructionSequence.compile("="); rescue SyntaxError => e; e.message != "compile error"; ensure; $stderr = stderr; end
          def error_message
            with_verbose do
              begin
                capture_stderr { RubyVM::InstructionSequence.compile(@source) }
              rescue SyntaxError => e
                e.message
              end
            end
          end
        else
          def error_message
            with_verbose do
              capture_stderr do
                begin
                  RubyVM::InstructionSequence.compile(@source)
                rescue SyntaxError
                end
              end
            end
          end
        end

        def with_verbose
          origin = $VERBOSE
          $VERBOSE = true
          yield
        ensure
          $VERBOSE = origin
        end

        def capture_stderr
          origin = $stderr
          $stderr = StringIO.new

          yield

          $stderr.string
        ensure
          $stderr = origin
        end
    end
  end
end
