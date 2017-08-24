module LanguageServer
  class Project
    class Node
      class << self
        def attributes(*attrs)
          attr_accessor(*attrs)
          attribute_names.concat(attrs)
          class_eval <<-RUBY, __FILE__, __LINE__
def initialize(#{attribute_names.map {|n| "#{n}:" }.join(',')})
  #{
    attribute_names.map {|n|
      "@#{n} = #{n}"
    }.join("\n")
  }
end
          RUBY
        end

        def attribute_names
          @attribute_names ||= superclass.respond_to?(:attribute_names) ? superclass.attribute_names.dup : []
        end
      end

      attributes :lineno, :character, :path

      def remote_path; path.remote_path; end
      def local_path;  path.local_path;  end

      def eql?(other)
        other.instance_of?(self.class) && attributes == other.attributes
      end

      def ==(other)
        eql?(other)
      end

      def hash
        self.attributes.hash
      end

      def attributes
        self.class.attribute_names.map {|a|
          [a, public_send(a)]
        }.to_h
      end
    end

    class Constant < Node
      attributes :namespaces, :name, :value

      def unshift_namespace(class_or_module)
        namespaces.unshift(class_or_module)
      end

      def names
        namespaces.flat_map(&:names) + [name]
      end

      def full_name
        names.join('::')
      end
    end

    class LiteralValue < Node
      attributes :value
    end

    class Module < Node
      attributes :constant, :children

      %i(name namespaces full_name names).each do |m|
        define_method(m) { constant.__send__(m) }
      end

      def unshift_namespace(class_or_module)
        constant.unshift_namespace(class_or_module)
      end

      def lines
        constant.lineno..lineno
      end

      def inspect
        "<Module #{full_name}#L#{lines.begin}-#{lines.end}>"
      end
    end

    class Class < Module
      attributes :superclass

      def inspect
        "<Class #{full_name}#L#{lines.begin}-#{lines.end}>"
      end
    end
  end
end
