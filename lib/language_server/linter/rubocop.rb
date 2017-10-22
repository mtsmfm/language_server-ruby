begin
  require 'rubocop'
rescue LoadError
end

module LanguageServer
  module Linter
    class Rubocop
      def initialize(path, config_path="")
        @path = path
        @config_path = config_path
      end


      def call
        return [] unless defined? ::RuboCop
        args = ["--format", "json", @path]
        args += ["--config", @config_path] if @config_path != ''
        options, paths = ::RuboCop::Options.new.parse(args)
        config_store = ::RuboCop::ConfigStore.new
        config_store.options_config = options[:config] if options[:config]
        o = nil
        begin
          $stdout = StringIO.new
          runner = ::RuboCop::Runner.new(options, config_store)
          runner.run(paths)
          o = $stdout.string
        ensure
          $stdout = STDOUT
        end
        return [] unless o
        JSON
          .parse(o)['files'].map { |v| v['offenses'] }
          .flatten
          .map { |v| Error.new(line_num: v['location']['line'].to_i - 1, message: v['message'], type: convert_type(v['severity'])) }
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
