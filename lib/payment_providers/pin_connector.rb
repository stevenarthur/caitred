module PaymentProviders
  class PinConnector
    def do_payment(charge)
      conn = Faraday.new(url: ENV['PIN_URL']) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.basic_auth(ENV['PIN_SECRET'], '')
      end
      response = conn.post('charges', charge.post_params_string)
      return if response.status == 201
      fail PaymentError, response.body
    end
  end
end
