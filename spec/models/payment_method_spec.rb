require 'rails_helper'

describe PaymentMethod do
  describe '#find' do

    it 'gets the matching payment method' do
      expect(PaymentMethod.find('Credit Card'))
        .to eq PaymentMethod::CREDIT_CARD
    end
  end
end
