require "languageserver/version"

module Languageserver
  class << self
    def run
      buffer = ""

      while char = STDIN.getc
        buffer << char
        $stderr.print char
      end
    end
  end
end
