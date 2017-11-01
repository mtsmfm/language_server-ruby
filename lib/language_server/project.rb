require 'language_server/project/parser'

module LanguageServer
  class Project
    def initialize(file_store)
      @file_store = file_store
      @result_store = {}

      fetch_result
    end

    def find_definitions(uri:, line:, character:)
      result = result_store[file_store.path_from_remote_uri(uri)]

      if result.nil?
        LanguageServer.logger.debug("result is nil in find_definitions.  Maybe we're still warming up?")
        return []
      end

      ref = result.refs.select {|node| node.lines.include?(line) && node.characters.include?(character) }.min_by {|node| node.characters.size }

      return [] unless ref

      lazy_modules.select {|n| n.full_name == ref.full_name }.force + lazy_classes.select {|n| n.full_name == ref.full_name }.force
    end

    def recalculate_result(uri)
      path = file_store.path_from_remote_uri(uri)
      calculate(file_store.read(path), path)
    end

    def things(uri: nil, line: nil, character: nil, group: nil)
      node = find_nearest_node(uri: uri, line: line, character: character) if uri && line && character
      if node == []
        LanguageServer.logger.debug("Node is an empty array?  Let's pass.")
        return []
      end

      result_store.each do |item|
        LanguageServer.logger.debug("item: #{item.inspect}")
      end

      group.select {|n| n.names[0..-2] == Array(node && node.names).first(n.names.size - 1) }.force
    end

    def constants(uri: nil, line: nil, character: nil)
      things(uri: uri, line: line, character: character, group: lazy_constants)
    end

    def modules(uri: nil, line: nil, character: nil)
      things(uri: uri, line: line, character: character, group: lazy_modules)
    end

    def classes(uri: nil, line: nil, character: nil)
      things(uri: uri, line: line, character: character, group: lazy_classes)
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
        calculate(content, path)
      }
    end

    def find_nearest_node(uri:, line:, character:)
      result = result_store[file_store.path_from_remote_uri(uri)]

      if result.nil?
        LanguageServer.logger.debug("result is nil in find_nearest_node.  Maybe we're still warming up?")
        return []
      end

      (result.modules + result.classes).select {|node| node.lines.include?(line) }.min_by {|node| node.lines.size }
    end

    def calculate(content, path)
      begin
        result = Parser.parse(content, path)
      rescue => e
        LanguageServer.logger.warn("Parse failed (local: #{path.local_path}, remote: #{path.remote_path})")
        LanguageServer.logger.warn(e)
      end

      result_store[path] = result if result
    end
  end
end
