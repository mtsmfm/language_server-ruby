$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bundler"
Bundler.require(:default, :development)

require "minitest/autorun"
require "power_assert/colorize"

class String
  def strip_heredoc
    min = scan(/^[ \t]*(?=\S)/).min
    indent = min ? min.size : 0
    gsub(/^[ \t]{#{indent}}/, "")
  end
end

Dir.glob(File.join(__dir__, "support", "**", "*.rb")).each { |f| require f }

class IntegrationTest < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def setup
    @server = TestServer.new

    switch_to_window(windows.last)

    assert_selector ".tab-label", text: /\AWelcome\z/, wait: 10
  end

  def teardown
    evaluate_script "electron.remote.app.quit()"

    puts @server.stderr.read unless passed?
  end

  def create_and_open_new_file(filename)
    find(".explorer-viewlet").click
    find(".action-label.new-file").click
    find(".explorer-item input").send_keys(filename)
    find(".explorer-item input").send_keys(:enter)
  end

  def input_contents(*contents)
    find(".monaco-editor textarea").send_keys(*contents)
  end

  def focus_text(text)
    input_contents :escape

    find("span", text: /\A#{Regexp.escape(text)}\z/).hover
  end

  def assert_error_message_on(text, message: nil)
    focus_text text

    options = message ? { text: /\A#{Regexp.escape(message)}\z/ } : {}

    assert_selector ".monaco-tokenized-source", options
  end

  def assert_no_error_message
    assert_selector ".task-statusbar-item-label-error+.task-statusbar-item-label-counter", text: /\A0\z/
  end
end
