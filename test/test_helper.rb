$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bundler'
Bundler.require(:default, :development)

require 'minitest/autorun'
require 'power_assert/colorize'

class String
  def strip_heredoc
    min = scan(/^[ \t]*(?=\S)/).min
    indent = min ? min.size : 0
    gsub(/^[ \t]{#{indent}}/, '')
  end
end
