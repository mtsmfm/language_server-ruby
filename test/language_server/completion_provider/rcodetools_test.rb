require "test_helper"

module LanguageServer
  module CompletionProvider
    class RcodetoolsTest < Minitest::Test
      def setup
        @uri = "file:///foo.rb"
        @file_store = FileStore.new
      end

      def test_array
        @file_store.cache(@uri, <<-EOS.strip_heredoc)
          [].l
        EOS

        provider = Rcodetools.new(uri: @uri, line: 0, character: 4, file_store: @file_store)

        candidates = [
          Protocol::Interface::CompletionItem.new(label: "last",   kind: Protocol::Constant::CompletionItemKind::METHOD, detail: "Array#last"),
          Protocol::Interface::CompletionItem.new(label: "lazy",   kind: Protocol::Constant::CompletionItemKind::METHOD, detail: "Enumerable#lazy"),
          Protocol::Interface::CompletionItem.new(label: "length", kind: Protocol::Constant::CompletionItemKind::METHOD, detail: "Array#length"),
        ]

        assert { provider.call.to_json == candidates.to_json }
      end

      def test_no_candidates
        @file_store.cache(@uri, <<-EOS.strip_heredoc)
          [].not_exists
        EOS

        provider = Rcodetools.new(uri: @uri, line: 0, character: 13, file_store: @file_store)

        assert { provider.call == [] }
      end

      def test_syntax_error
        @file_store.cache(@uri, <<-EOS.strip_heredoc)
          class Foo
          [].l
        EOS

        provider = Rcodetools.new(uri: @uri, line: 1, character: 4, file_store: @file_store)

        assert { provider.call == [] }
      end

      def test_runtime_error
        @file_store.cache(@uri, <<-EOS.strip_heredoc)
          require "not_exists"
          [].l
        EOS

        provider = Rcodetools.new(uri: @uri, line: 1, character: 4, file_store: @file_store)

        assert { provider.call == [] }
      end
    end
  end
end
