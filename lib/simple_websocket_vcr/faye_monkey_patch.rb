module Faye
  class WebSocket
    class Client
      class << self
        alias_method :real_new, :new

        def new(url, protocols = nil, options = {})
          if WebSocketVCR.configuration.hook_uris.any? { |u| url.include?(u) }
            cassette = WebSocketVCR.cassette
            live = cassette.recording?
            real_client = real_new(url, protocols, options) if live
            fake_client = WebSocketVCR::RecordableFayeWebsocketClient.new(cassette, live ? real_client : nil)
          else
            real_new(url, protocols, options)
          end
        end
      end
    end
  end
end
