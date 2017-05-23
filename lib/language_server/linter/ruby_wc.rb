require "open3"
require "tempfile"
require "shellwords"

module LanguageServer
  module Linter
    class Error
      attr_reader :line_num, :message

      def initialize(line_num:, message:)
        @line_num = line_num
        @message = message
      end

      def syntax_error?
        @message.start_with?("syntax error")
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

          err.lines.chunk {|line| line.start_with?(file.path) }.map(&:last).each_slice(2).map(&:flatten).map do |lines|
            line_num, message = lines[0].scan(/#{Regexp.escape(path)}:(\d+): (.*)\n/).flatten
            Error.new(line_num: line_num.to_i, message: message)
          end
        end
      end
    end
  end
end