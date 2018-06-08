require "test_helper"
require "open3"

class LanguageServerTest < IntegrationTest
  def test_syntax_check
    create_and_open_new_file "a.rb"

    input_contents "def hi"
    assert_error_message_on "hi", message: "unexpected end-of-input, expecting ';' or '\\n'"

    input_contents :enter
    input_contents "end"

    assert_no_error_message
  end
end
