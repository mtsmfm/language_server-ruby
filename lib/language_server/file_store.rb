require "uri"

module LanguageServer
  class FileStore
    include Enumerable

    def initialize(load_paths = [])
      @load_paths = load_paths
    end

    def cache(uri_or_path, content)
      cache_store[to_path(uri_or_path)] = content
    end

    def read(uri_or_path)
      path = to_path(uri_or_path)

      if exists_on_cache?(path)
        read_from_cache(path)
      else
        read_from_local(path)
      end
    end

    def each(&block)
      all_file_paths.each do |path|
        block.call(read(path))
      end
    end

    def all_file_paths
      cache_store.keys + load_paths.flat_map {|path| Dir.glob(File.join(path, "**", "*.rb")) }
    end

    private

    attr_reader :load_paths

    def to_path(uri_or_path)
      URI(uri_or_path).path
    end

    def exists_on_cache?(path)
      cache_store.key?(path)
    end

    def read_from_cache(path)
      cache_store[path]
    end

    def read_from_local(path)
      File.read(path)
    end

    def cache_store
      @cache_store ||= {}
    end
  end
end
