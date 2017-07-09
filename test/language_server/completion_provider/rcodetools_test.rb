require 'test_helper'

module LanguageServer
  module CompletionProvider
    class RcodetoolsTest < Minitest::Test
      def setup
        @uri = "file:///foo.rb"
        @file_store = FileStore.new
      end

      def test_array
        @file_store.cache(@uri, <<~EOS)
          [].l
        EOS

        provider = Rcodetools.new(uri: @uri, line: 0, character: 4, file_store: @file_store)

        candidates = [
          Candidate.new(method_name: "last",   description: "Array#last"),
          Candidate.new(method_name: "lazy",   description: "Enumerable#lazy"),
          Candidate.new(method_name: "length", description: "Array#length")
        ]

        assert { provider.call == candidates }
      end

      def test_no_candidates
        @file_store.cache(@uri, <<~EOS)
          [].not_exists
        EOS

        provider = Rcodetools.new(uri: @uri, line: 0, character: 13, file_store: @file_store)

        assert { provider.call == [] }
      end

      def test_syntax_error
        @file_store.cache(@uri, <<~EOS)
          class Foo
          [].l
        EOS

        provider = Rcodetools.new(uri: @uri, line: 1, character: 4, file_store: @file_store)

        assert { provider.call == [] }
      end

      def test_runtime_error
        @file_store.cache(@uri, <<~EOS)
          require "not_exists"
          [].l
        EOS

        provider = Rcodetools.new(uri: @uri, line: 1, character: 4, file_store: @file_store)

        assert { provider.call == [] }
      end
    end
  end
end
