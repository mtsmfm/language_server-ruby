module LanguageServer
  module Protocol
    module Interfaces
      class TextDocumentSyncOptions
        def initialize(open_close: nil, change: nil, will_save: nil, will_save_wait_until: nil, save: nil)
          @attributes = {}

          @attributes[:openClose] = open_close if open_close
          @attributes[:change] = change if change
          @attributes[:willSave] = will_save if will_save
          @attributes[:willSaveWaitUntil] = will_save_wait_until if will_save_wait_until
          @attributes[:save] = save if save

          @attributes.freeze
        end

        #
        # Open and close notifications are sent to the server.
        #
        # @return [boolean]
        def open_close
          attributes.fetch(:openClose)
        end

        #
        # Change notificatins are sent to the server. See TextDocumentSyncKind.None, TextDocumentSyncKind.Full
        # and TextDocumentSyncKindIncremental.
        #
        # @return [number]
        def change
          attributes.fetch(:change)
        end

        #
        # Will save notifications are sent to the server.
        #
        # @return [boolean]
        def will_save
          attributes.fetch(:willSave)
        end

        #
        # Will save wait until requests are sent to the server.
        #
        # @return [boolean]
        def will_save_wait_until
          attributes.fetch(:willSaveWaitUntil)
        end

        #
        # Save notifications are sent to the server.
        #
        # @return [SaveOptions]
        def save
          attributes.fetch(:save)
        end

        attr_reader :attributes

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end
  end
end
