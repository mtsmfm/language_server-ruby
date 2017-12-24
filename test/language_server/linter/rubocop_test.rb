require "test_helper"

module LanguageServer::Linter
  class RubocopTest < Minitest::Test
    def setup
      @config_path = File.expand_path("./../../../fixtures/rubocop.yml", __FILE__)
    end

    def test_fatal_error
      source = 'require "foo'
      actual = Rubocop.new(source, @config_path).call
      assert do
        actual.first == Error.new(line_num: 0, message: "Lint/Syntax: unterminated string meets end of file\n(Using Ruby 2.1 parser; configure using `TargetRubyVersion` parameter, under `AllCops`)", type: "error")
      end
    end

    def test_warning_error
      source = "a = 'a'"
      actual = Rubocop.new(source, @config_path).call
      assert do
        actual.first == Error.new(line_num: 0, message: "Lint/UselessAssignment: Useless assignment to variable - `a`.", type: "warning")
      end
    end

    def test_convention_error
      source = 'require "foo"'
      actual = Rubocop.new(source, @config_path).call
      assert do
        actual.first == Error.new(line_num: 0, message: "Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.", type: "warning")
      end
    end
  end
end
