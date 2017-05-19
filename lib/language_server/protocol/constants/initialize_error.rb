module LanguageServer
  module Protocol
    module Constants
      #
      # Known error codes for an `InitializeError`;
      #
      module InitializeError
        #
        # If the protocol version provided by the client can't be handled by the server.
        #
        UNKNOWN_PROTOCOL_VERSION = 1
      end
    end
  end
end
