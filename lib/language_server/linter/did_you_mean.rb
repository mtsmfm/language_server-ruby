require "open3"
require "language_server/linter/error"

module LanguageServer
  module Linter
    class DidYouMean
      def initialize(source)
        @source = source
      end

      def call
        out, _, _ = Open3.capture3("ruby -r bundler/setup -r did_you_mean/static", stdin_data: @source)

        (JSON.parse(out, symbolize_names: true)[:undefined_names] || {}).values.flatten.map do |undefined_name:, symbol_type:, path:, lineno:, suggestions:|
          Error.new(line_num: lineno - 1, message: "Undefined method #{undefined_name}. Did you mean? #{suggestions.join("\n")}", type: 'warning')
        end
      end
    end
  end
end
