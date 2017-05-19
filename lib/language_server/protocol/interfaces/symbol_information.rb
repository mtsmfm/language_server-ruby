module LanguageServer
  module Protocol
    module Interfaces
      #
      # Represents information about programming constructs like variables, classes,
      # interfaces etc.
      #
      class SymbolInformation
        def initialize(name:, kind:, location:, container_name: nil)
          @attributes = {}

          @attributes[:name] = name
          @attributes[:kind] = kind
          @attributes[:location] = location
          @attributes[:containerName] = container_name if container_name

          @attributes.freeze
        end

        #
        # The name of this symbol.
        #
        # @return [string]
        def name
          attributes.fetch(:name)
        end

        #
        # The kind of this symbol.
        #
        # @return [number]
        def kind
          attributes.fetch(:kind)
        end

        #
        # The location of this symbol.
        #
        # @return [Location]
        def location
          attributes.fetch(:location)
        end

        #
        # The name of the symbol containing this symbol.
        #
        # @return [string]
        def container_name
          attributes.fetch(:containerName)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
