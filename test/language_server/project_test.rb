require 'test_helper'

module LanguageServer
  class ProjectTest < Minitest::Test
    def test_const
      file_store = FileStore.new
      file_store.cache("file:///foo.rb", <<~EOS)
        TOPLEVE_CONST = 1

        module ::Nested::Mod
          class Klass
            CONST_1 = 1

            ::Mod::CONST_2 = 2
          end
        end
      EOS

      project = Project.new(file_store)

      assert { project.constants.map(&:fullname).sort == %i(TOPLEVE_CONST Nested::Mod Mod::CONST_2 Nested::Mod::Klass Nested::Mod::Klass::CONST_1).sort }
    end

    def test_skip_error
      file_store = FileStore.new
      file_store.cache("file:///foo.rb", <<~EOS)
        TOPLEVE_CONST = 1
      EOS

      file_store.cache("file:///bar.rb", <<~EOS)
        def
      EOS

      project = Project.new(file_store)

      assert { project.constants.map(&:fullname) == %i(TOPLEVE_CONST) }
    end
  end
end
