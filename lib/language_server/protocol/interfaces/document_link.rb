module LanguageServer
  module Protocol
    module Interfaces
      #
      # A document link is a range in a text document that links to an internal or external resource, like another
      # text document or a web site.
      #
      class DocumentLink
        def initialize(range:, target: nil)
          @attributes = {}

          @attributes[:range] = range
          @attributes[:target] = target if target

          @attributes.freeze
        end

        #
        # The range this link applies to.
        #
        # @return [Range]
        def range
          attributes.fetch(:range)
        end

        #
        # The uri this link points to. If missing a resolve request is sent later.
        #
        # @return [string]
        def target
          attributes.fetch(:target)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
