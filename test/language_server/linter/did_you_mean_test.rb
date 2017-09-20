require 'test_helper'

module LanguageServer::Linter
  class DidYouMeanTest < Minitest::Test
    def test_error
      linter = DidYouMean.new(<<-EOS.strip_heredoc)
        def hi
          foo
        end
      EOS

      assert {
        linter.call == [Error.new(line_num: 1, message: "Undefined method foo. Did you mean? for", type: "warning")]
      }
    end
  end
end
