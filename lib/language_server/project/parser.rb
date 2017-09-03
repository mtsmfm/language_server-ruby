require 'parser/current'

module LanguageServer
  class Project
    class Parser
      class Node < ::Parser::AST::Node
        def initialize(*)
          @mutable_attributes = {}

          super
        end

        def child_nodes
          children.select {|child| child.is_a?(self.class) }
        end

        def parent=(node)
          @mutable_attributes[:parent] = node
        end

        def parent
          @mutable_attributes[:parent]
        end
      end

      class Builder < ::Parser::Builders::Default
        def n(type, children, source_map)
          Node.new(type, children, location: source_map)
        end
      end

      class << self
        def parse(source)
          parser = ::Parser::CurrentRuby.new(Builder.new)
          buffer = ::Parser::Source::Buffer.new("(string)")
          buffer.source = source
          parser.parse(buffer).tap do |node|
            assign_parent(node) if node
          end
        rescue ::Parser::SyntaxError
          nil
        end

        private

        def assign_parent(node)
          node.child_nodes.each do |child|
            child.parent = node

            assign_parent(child)
          end
        end
      end
    end
  end
end
