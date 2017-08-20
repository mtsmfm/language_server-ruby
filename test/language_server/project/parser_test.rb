require 'test_helper'

module LanguageServer
  class Project
    class ParserTest < Minitest::Test
      def test_toplevel_const
        body = <<-EOS.strip_heredoc
          TOP_LEVEL_CONST = 1
        EOS

        result = Parser.parse(body)

        assert { result.constants.map(&:full_name) == %w(TOP_LEVEL_CONST) }
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

        assert { result.modules.map(&:full_name) == %w(Cls::Mod) }
        assert { result.constants.map(&:full_name) == %w(Cls::Mod::CONST) }
      end

      def test_class
        body = <<-EOS.strip_heredoc
          class Hi
          end
        EOS

        result = Parser.parse(body)

        assert { result.classes.map(&:full_name) == %w(Hi) }
      end

      def test_module
        body = <<-EOS.strip_heredoc
          module Hi
          end
        EOS

        result = Parser.parse(body)

        assert { result.modules.map(&:full_name) == %w(Hi) }
      end

      def test_module_with_method
        body = <<-EOS.strip_heredoc
          module Hi
            def initialize
            end
          end
        EOS

        result = Parser.parse(body)

        assert { result.modules.map(&:full_name) == %w(Hi) }
      end
    end
  end
end
