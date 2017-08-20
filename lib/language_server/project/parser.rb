require 'language_server/project/node'
require 'ripper'

module LanguageServer
  class Project
    class Parser < Ripper
      class Result
        attr_reader :constants, :classes, :modules

        def initialize
          @constants = []
          @classes = []
          @modules = []
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
        @current_constants = []
      end

      private

      attr_reader :path

      def lineno
        # Language Server Protocol's lineno is zero origin
        super - 1
      end

      def on_const(name)
        Constant.new(namespaces: [], name: name, value: nil, lineno: lineno, path: path).tap do |c|
          @current_constants.push(c)
        end
      end

      def on_int(value)
        LiteralValue.new(value: value.to_i, lineno: lineno, path: path)
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
        cn = children.select {|child| child.instance_of?(Constant) || child.instance_of?(Module) || child.instance_of?(Class)}
        Module.new(constant: constant, lineno: lineno, path: path, children: cn).tap do |m|
          result.modules << m
          cn.each {|child| child.unshift_namespace(m) }
        end
      end

      def on_class(constant, superclass, children)
        cn = children.select {|child| child.instance_of?(Constant) || child.instance_of?(Module) || child.instance_of?(Class)}
        Class.new(constant: constant, superclass: superclass, lineno: lineno, path: path, children: cn).tap do |c|
          result.classes << c
          cn.each {|child| child.unshift_namespace(c) }
        end
      end
    end
  end
end
