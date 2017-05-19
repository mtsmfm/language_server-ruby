module LanguageServer
  module Protocol
    module Interfaces
      class Location
        def initialize(uri:, range:)
          @attributes = {}

          @attributes[:uri] = uri
          @attributes[:range] = range

          @attributes.freeze
        end

        # @return [string]
        def uri
          attributes.fetch(:uri)
        end

        # @return [Range]
        def range
          attributes.fetch(:range)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
