require "uri"

module LanguageServer
  class FileStore
    include Enumerable

    class FilePath
      class << self
        def from_remote_uri(remote_root:, local_root:, remote_uri:)
          new(remote_root: remote_root, local_root: local_root, local_path: URI(remote_uri).path.sub(remote_root, local_root))
        end
      end

      attr_reader :local_root, :remote_root, :local_path

      def initialize(remote_root:, local_root:, local_path:)
        @remote_root = remote_root
        @local_root = local_root
        @local_path = local_path
      end

      def remote_path
        @remote_path ||= local_path.sub(local_root, remote_root)
      end

      def eql?(other)
        self.class == other.class && remote_path == other.remote_path
      end

      def ==(other)
        eql?(other)
      end

      def hash
        self.remote_path.hash
      end
    end

    def initialize(load_paths: [], remote_root: Dir.getwd, local_root: Dir.getwd)
      @load_paths = load_paths
      @remote_root = remote_root
      @local_root = local_root
    end

    def cache(remote_uri, content)
      cache_store[path_from_remote_uri(remote_uri)] = content
    end

    def path_from_remote_uri(remote_uri)
      FilePath.from_remote_uri(local_root: local_root, remote_root: remote_root, remote_uri: remote_uri)
    end

    def read(path)
      if exists_on_cache?(path)
        read_from_cache(path)
      else
        read_from_local(path)
      end
    end

    def read_remote_uri(remote_uri)
      read(path_from_remote_uri(remote_uri))
    end

    def each(&block)
      all_paths.each do |path|
        block.call(read(path), path)
      end
    end

    private

    attr_reader :load_paths, :remote_root, :local_root

    def all_paths
      (cache_store.keys + load_paths.flat_map {|path|
        Dir.glob(File.join(path, "**", "*.rb"))
      }.map {|path|
        FilePath.new(local_root: local_root, remote_root: remote_root, local_path: path)
      }).uniq
    end

    def exists_on_cache?(path)
      cache_store.key?(path)
    end

    def read_from_cache(path)
      cache_store[path]
    end

    def read_from_local(path)
      File.read(path.local_path)
    end

    def cache_store
      @cache_store ||= {}
    end
  end
end
