require 'test_helper'

module LanguageServer::Linter
  class RubyWCTest < Minitest::Test
    def test_error
      linter = RubyWC.new(<<~EOS)
        require "hoge
        if buffer[-4..-1] == "\r\n"
      EOS

      assert {
        linter.call == [
          Error.new(line_num: 2, message: "syntax error, unexpected $undefined, expecting end-of-input")
        ]
      }
    end

    def test_warn

    end
  end
end