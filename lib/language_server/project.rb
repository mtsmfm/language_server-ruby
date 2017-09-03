require 'language_server/project/parser'
require 'language_server/project/processor'

module LanguageServer
  class Project
    def initialize(file_store)
      @file_store = file_store
    end

    def constants
      file_store.lazy.map {|content|
        Parser.parse(content)
      }.select(&:itself).flat_map {|root_node|
        processor = Processor.new
        processor.process(root_node)
        processor.result.constants
      }.force
    end

    private

    attr_reader :file_store
  end
end
