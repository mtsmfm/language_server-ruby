require "open3"

module LanguageServer
  module Linter
    class Rubocop
      def initialize(path, config_path="")
        @path = path
        @config_path = config_path
      end

      def call
        Bundler.with_clean_env do
          command = "rubocop #{@path} --format json --force-exclusion"
          command += " --config #{@config_path}" if @config_path != ""
          o, err, _ = Open3.capture3(command)
          return [Error.new(line_num: 0, message: err, type: 'error')] if err != ""
          JSON
            .parse(o)['files'].map { |v| v['offenses'] }
            .flatten
            .map { |v| Error.new(line_num: v['location']['line'].to_i - 1, message: v['message'], type: convert_type(v['severity'])) }
        end
      end

      private

      def convert_type(type)
        case type
        when 'refactor' then 'warning'
        when 'convention' then 'warning'
        when 'warning' then 'warning'
        when 'error' then 'error'
        when 'fatal' then 'error'
        end
      end

    end
  end
end
