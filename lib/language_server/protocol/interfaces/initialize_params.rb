module LanguageServer
  module Protocol
    module Interfaces
      class InitializeParams
        def initialize(process_id:, root_path: nil, root_uri:, initialization_options: nil, capabilities:, trace: nil)
          @attributes = {}

          @attributes[:processId] = process_id
          @attributes[:rootPath] = root_path if root_path
          @attributes[:rootUri] = root_uri
          @attributes[:initializationOptions] = initialization_options if initialization_options
          @attributes[:capabilities] = capabilities
          @attributes[:trace] = trace if trace

          @attributes.freeze
        end

        #
        # The process Id of the parent process that started
        # the server. Is null if the process has not been started by another process.
        # If the parent process is not alive then the server should exit (see exit notification) its process.
        #
        # @return [number]
        def process_id
          attributes.fetch(:processId)
        end

        #
        # The rootPath of the workspace. Is null
        # if no folder is open.
        #
        # @return [string]
        def root_path
          attributes.fetch(:rootPath)
        end

        #
        # The rootUri of the workspace. Is null if no
        # folder is open. If both `rootPath` and `rootUri` are set
        # `rootUri` wins.
        #
        # @return [string]
        def root_uri
          attributes.fetch(:rootUri)
        end

        #
        # User provided initialization options.
        #
        # @return [any]
        def initialization_options
          attributes.fetch(:initializationOptions)
        end

        #
        # The capabilities provided by the client (editor or tool)
        #
        # @return [ClientCapabilities]
        def capabilities
          attributes.fetch(:capabilities)
        end

        #
        # The initial trace setting. If omitted trace is disabled ('off').
        #
        # @return ["off" | "messages" | "verbose"]
        def trace
          attributes.fetch(:trace)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
