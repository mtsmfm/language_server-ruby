require "test_helper"

module LanguageServer
  class Project
    class ParserTest < Minitest::Test
      def test_toplevel_const
        body = <<-EOS.strip_heredoc
          TOP_LEVEL_CONST = 1
        EOS

        result = Parser.parse(body)

        assert { result.constants.map(&:full_name) == %w[TOP_LEVEL_CONST] }
      end

      def test_const_within_class_and_module
        body = <<-EOS.strip_heredoc
          class Cls
            module Mod
              CONST = 1
            end
          end
        EOS

        result = Parser.parse(body)

        assert { result.modules.map(&:full_name) == %w[Cls::Mod] }
        assert { result.constants.map(&:full_name) == %w[Cls::Mod::CONST] }
      end

      def test_class
        body = <<-EOS.strip_heredoc
          class Hi
          end
        EOS

        result = Parser.parse(body)

        assert { result.classes.map(&:full_name) == %w[Hi] }
      end

      def test_module
        body = <<-EOS.strip_heredoc
          module Hi
          end
        EOS

        result = Parser.parse(body)

        assert { result.modules.map(&:full_name) == %w[Hi] }
      end

      def test_module_with_method
        body = <<-EOS.strip_heredoc
          module Hi
            def initialize
            end
          end
        EOS

        result = Parser.parse(body)

        assert { result.modules.map(&:full_name) == %w[Hi] }
      end

      def test_ref
        result = Parser.parse(<<-EOS.strip_heredoc)
          A
        EOS

        assert { result.refs.map { |r| [r.full_name, r.characters] } == [["A", 0..1]] }
      end

      def test_ref_2
        result = Parser.parse(<<-EOS.strip_heredoc)
          A::B
        EOS

        assert { result.refs.map { |r| [r.full_name, r.characters] } == [["A", 0..2], ["A::B", 0..3]] }
      end

      def test_ref_3
        result = Parser.parse(<<-EOS.strip_heredoc)
          A::B::C
        EOS

        assert { result.refs.map { |r| [r.full_name, r.characters] } == [["A", 0..2], ["A::B", 0..3], ["A::B::C", 0..6]] }
      end

      def test_ref_within_module
        result = Parser.parse(<<-EOS.strip_heredoc)
          module A
            B
          end
        EOS

        assert { result.refs.map { |r| [r.full_name, r.characters] } == [["A::B", 2..3]] }

        result = Parser.parse(<<-EOS.strip_heredoc)
          module A
            B::C
          end
        EOS

        assert { result.refs.map { |r| [r.full_name, r.characters] } == [["A::B", 2..4], ["A::B::C", 2..5]] }
      end

      def test_const_ref_with_method
        result = Parser.parse(<<-EOS.strip_heredoc)
          class.self::FOO
        EOS

        assert { result.refs == [] }
      end

      def test_inline_nested_class
        result = Parser.parse(<<-EOS.strip_heredoc)
          module A
            module B
              class C::D::E
              end
            end
          end
        EOS

        assert { result.classes.map(&:full_name) == %w[A::B::C::D::E] }
      end
    end
  end
end
