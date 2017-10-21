require 'test_helper'

module LanguageServer
  class Project
    class NodeTest < Minitest::Test

      def node_attributes
        {lineno: 1, character: 'a', path: nil}
      end

      def test_node_attribute_names
        assert_equal(Node.attribute_names, [:lineno, :character, :path])
      end

      def test_node_should_have_attributes
        attributes = node_attributes
        node = Node.new(attributes)
        assert_equal(node.attributes, attributes)
      end

      def test_literal_value_attribute_names
        assert_equal(LiteralValue.attribute_names, [:lineno, :character, :path, :value])
      end

      def literal_value_should_have_literal_value
        lv = :foo
        test_object = LiteralValue.new(node_attributes.merge(literal_value: lv))
        assert_equal(test_object.literal_value, lv)
      end

    end
  end
end
