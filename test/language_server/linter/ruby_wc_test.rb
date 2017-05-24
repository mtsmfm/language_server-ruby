require 'test_helper'

module LanguageServer::Linter
  class RubyWCTest < Minitest::Test
    def test_error
      linter = RubyWC.new(<<~EOS)
        require "foo
        if a == "\\n"
      EOS

      assert {
        linter.call == [Error.new(line_num: 2, message: "unexpected $undefined, expecting end-of-input", type: "syntax error")]
      }
    end

    def test_warn
      linter = RubyWC.new(<<~RUBY)
        a = 1
      RUBY

      assert {
        linter.call == [Error.new(line_num: 1, message: "assigned but unused variable - a", type: "warning")]
      }
    end
  end
end
