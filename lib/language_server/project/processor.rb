require 'rubocop/ast/traversal'

module LanguageServer
  class Project
    class Processor
      include ::RuboCop::AST::Traversal

      Constant = Struct.new(:namespaces, :name, :value) do
        def fullname
          (namespaces.map(&:name) + [name]).join('::').to_sym
        end
      end
      class Class < Constant; end
      class Module < Constant; end

      class Result
        def initialize(constants:)
          @constants = constants
        end

        attr_reader :constants
      end

      module Helper
        module_function

        def flatten_nested_constant(const_node)
          raise ArgumentError unless const_node.type == :const

          result = [const_node]
          result.push(const_node) while const_node = const_node&.children[0]
          result.reverse
        end
      end

      class NamespaceStack
        def initialize
          @stack = []
        end

        def push(node)
          const_nodes = Helper.flatten_nested_constant(node.children[0])

          @stack.push(const_nodes.map {|n| Namespace.new(n)})
        end

        def pop
          @stack.pop
        end

        def namespaces
          @stack.flatten.reverse.take_while {|n| !n.toplevel? }.reverse
        end
      end

      class Namespace
        def initialize(node, type = nil)
          @node = node
          @type = type
        end

        def name
          @name ||= toplevel? ? :main : @node.children[1]
        end

        def inspect
          "#<Namespace #{name.inspect}>"
        end

        def toplevel?
          @node.type == :cbase
        end
      end

      def initialize
        @constants = []
        @namespace_stack = NamespaceStack.new
      end

      alias process walk

      def on_module(node)
        @namespace_stack.push(node)
        *namespaces, current = @namespace_stack.namespaces
        @constants << Module.new(namespaces, current.name, node)
        super
        @namespace_stack.pop
      end

      def on_class(node)
        @namespace_stack.push(node)
        *namespaces, current = @namespace_stack.namespaces
        @constants << Class.new(namespaces, current.name, node)
        super
        @namespace_stack.pop
      end

      def on_casgn(node)
        scope_node, name, value = node.children

        namespaces = @namespace_stack.namespaces

        if scope_node
          inline_namespaces = Helper.flatten_nested_constant(scope_node).map {|n| Namespace.new(n) }
          namespaces = inline_namespaces[1..-1] if inline_namespaces[0].toplevel?
        end

        @constants << Constant.new(namespaces, name, value)

        super
      end

      def result
        Result.new(constants: @constants)
      end
    end
  end
end
