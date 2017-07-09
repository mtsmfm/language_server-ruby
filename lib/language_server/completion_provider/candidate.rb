module LanguageServer
  module CompletionProvider
    class Candidate
      attr_reader :method_name, :description

      def initialize(method_name:, description:)
        @method_name = method_name
        @description = description
      end

      def ==(other)
        method_name == other.method_name && description == other.description
      end
    end
  end
end
