module LanguageServer
  class UriStore
    class << self
      def []=(uri, content)
        store[uri] = content
      end

      def [](uri)
        store[uri]
      end

      def clear
        store.clear
      end

      private

      def store
        @store ||= {}
      end
    end
  end
end
