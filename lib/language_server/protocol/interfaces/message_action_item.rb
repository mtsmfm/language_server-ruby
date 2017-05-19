module LanguageServer
  module Protocol
    module Interfaces
      class MessageActionItem
        def initialize(title:)
          @attributes = {}

          @attributes[:title] = title

          @attributes.freeze
        end

        #
        # A short title like 'Retry', 'Open Log' etc.
        #
        # @return [string]
        def title
          attributes.fetch(:title)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
