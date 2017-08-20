require 'language_server/project/parser'

module LanguageServer
  class Project
    def initialize(file_store)
      @file_store = file_store
      @result_store = {}

      fetch_result
    end

    def recalculate_result(uri)
      path = file_store.path_from_remote_uri(uri)
      result_store[path] = calculate(file_store.read(path), path)
    end

    def constants(uri: nil, line: nil, character: nil)
      node = find_nearest_node(uri: uri, line: line, character: character) if uri && line && character

      lazy_constants.select {|n| n.names[0..-2] == Array(node && node.names).first(n.names.size - 1) }.force
    end

    def modules(uri: nil, line: nil, character: nil)
      node = find_nearest_node(uri: uri, line: line, character: character) if uri && line && character

      lazy_modules.select {|n| n.names[0..-2] == Array(node && node.names).first(n.names.size - 1) }.force
    end

    def classes(uri: nil, line: nil, character: nil)
      node = find_nearest_node(uri: uri, line: line, character: character) if uri && line && character

      lazy_classes.select {|n| n.names[0..-2] == Array(node && node.names).first(n.names.size - 1) }.force
    end

    private

    attr_reader :file_store, :result_store

    def lazy_constants
      result_store.each_value.lazy.flat_map(&:constants)
    end

    def lazy_modules
      result_store.each_value.lazy.flat_map(&:modules)
    end

    def lazy_classes
      result_store.each_value.lazy.flat_map(&:classes)
    end

    def fetch_result
      file_store.each {|content, path|
        result_store[path] = calculate(content, path)
      }
    end

    def find_nearest_node(uri:, line:, character:)
      result = result_store[file_store.path_from_remote_uri(uri)]

      (result.modules + result.classes).select {|node| node.lines.include?(line) }.min_by {|node| node.lines.size }
    end

    def calculate(content, path)
      Parser.parse(content, path)
    end
  end
end
