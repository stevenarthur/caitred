require 'rails_helper'

module Xero
  describe XeroClient do
    before do
      allow(Xeroizer::PrivateApplication).to receive(:new)
    end

    it 'creates a new client using Xeroizer' do
      XeroClient.client
      expect(Xeroizer::PrivateApplication).to have_received(:new)
    end
  end
end
