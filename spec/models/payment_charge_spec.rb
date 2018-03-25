require 'rails_helper'

describe PaymentCharge do
  let(:email) { 'big@bird.com' }
  let(:ip_address) { '10.0.0.1' }
  let(:token) { 'token' }
  let(:customer) { create(:customer, email: email) }
  let(:request) { double(:request, remote_ip: ip_address) }
  let(:enquiry) do
    enquiry = create(
      :enquiry,
      customer: customer
    )
    allow(enquiry).to receive(:amount_to_pay).and_return 100
    enquiry
  end
  describe '#post_params' do
    let(:params) { PaymentCharge.new(enquiry, request, token).post_params }

    it 'includes the customer email' do
      expect(params[:email]).to eq email
    end

    it 'includes the ip address' do
      expect(params[:ip_address]).to eq ip_address
    end

    it 'includes a description' do
      expect(params[:description]).not_to be_nil
    end

    it 'includes an amount' do
      expect(params[:amount]).to eq 10_000
    end

    it 'includes a currency' do
      expect(params[:currency]).to eq 'AUD'
    end

    it 'includes the token' do
      expect(params[:card_token]).to eq token
    end
  end

  describe '#post_params_string' do
    let(:params_string) { PaymentCharge.new(enquiry, request, token).post_params_string }

    it 'turns the params into a string' do
      expect(params_string).to include token
    end
  end
end
