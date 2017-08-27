require 'language_server/project/node'
require 'ripper'

module LanguageServer
  class Project
    class Parser < Ripper
      class Result
        attr_reader :constants, :classes, :modules, :refs

        def initialize
          @constants = []
          @classes = []
          @modules = []
          @refs = []
        end
      end

      class << self
        def parse(src, path = nil)
          new(src, path).tap(&:parse).result
        end
      end

      attr_reader :result

      def initialize(src, path)
        super(src, path && path.remote_path)

        @path = path
        @result = Result.new
      end

      private

      alias character column

      attr_reader :path

      def lineno
        # Language Server Protocol's lineno is zero origin
        super - 1
      end

      def on_var_ref(node)
        if node.instance_of?(Constant)
          build_node(VarRef, node: node).tap do |n|
            result.refs << n
          end
        else
          node
        end
      end

      def on_const_path_ref(*nodes)
        if nodes.all? {|n| [Constant, ConstPathRef, VarRef].include?(n.class) }
          build_node(ConstPathRef, nodes: nodes).tap do |n|
            result.refs << n
          end
        else
          nodes
        end
      end

      def on_const(name)
        build_node(Constant, namespaces: [], name: name, value: nil)
      end

      def on_def(*args)
        args.flatten.compact
      end

      def on_int(value)
        build_node(LiteralValue, value: value.to_i)
      end

      def on_stmts_add(*args)
        args.flatten.compact
      end

      def on_assign(left, right)
        result.constants << left if Constant === left

        left.value = right if left.respond_to?(:value) # TODO: remove this condition
        left
      end

      def on_module(constant, children)
        cn = children.select {|child| child.respond_to?(:unshift_namespace) }

        build_node(Module, constant: constant, children: cn).tap do |m|
          result.modules << m
          cn.each {|child| child.unshift_namespace(m) }
        end
      end

      def on_class(constant, superclass, children)
        cn = children.select {|child| child.respond_to?(:unshift_namespace) }

        build_node(Class, constant: constant, superclass: superclass, children: cn).tap do |c|
          result.classes << c
          cn.each {|child| child.unshift_namespace(c) }
        end
      end

      def build_node(klass, **args)
        klass.new({lineno: lineno, character: character, path: path}.merge(args))
      end
    end
  end
end
