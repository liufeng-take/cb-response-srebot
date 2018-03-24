require 'lita/helpers/cb_response_helpers'

module Lita
  module Handlers
    class CbResponseEmbedded < Handler
      include CbResponseHelpers

      route(/cb status/, restrict_to: nil, help: {'cb status' => 'Returns the status of the ACME Cb server'}) do |lita_response|
        lita_response.reply 'checking the status of the cb-enterprise service...'
        cb_service_status = cb_response_status
        lita_response.reply service_status_to_bot_message(cb_service_status)
      end

      route(/^cb restart/, restrict_to: nil, help: {'cb restart' => 'Restarts the Cb server services'}) do |lita_response|
        lita_response.reply 'restarting the cb-enterprise service...'
        cb_service_status = stop_cb_response
        lita_response.reply 'cb-enterprise stopped...'
        cb_service_status = start_cb_response
        lita_response.reply service_status_to_bot_message(cb_service_status)
      end

      Lita.register_handler(self)
    end
  end
end
