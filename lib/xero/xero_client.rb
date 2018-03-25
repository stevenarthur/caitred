module Xero
  module XeroClient
    def self.client
		  @client || Xeroizer::PrivateApplication.new(
        ENV['XERO_CONSUMER_KEY'],
        ENV['XERO_CONSUMER_SECRET'],
        if Rails.env.production?
          File.join(Rails.root, 'privatekey.pem')
        else
          File.join(Rails.root, 'privatekey-dev.pem')
        end
      )
    end
  end
end
