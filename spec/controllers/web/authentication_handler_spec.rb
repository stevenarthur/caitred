require 'rails_helper'

class WithWebAuthController < WebsiteController
  attr_accessor :current_customer_session
  before_filter :require_logged_in_customer
  def account
    head 200
  end
end

describe WithWebAuthController, type: :controller do
  let(:session) { double(:session, id: '123', :[] => nil) }

  before do
    allow(controller).to receive(:session)
      .and_return(session)
    Rails.application.routes.draw do
      get :account, to: 'with_web_auth#account'
      get :login, to: 'with_web_auth#login', as: 'customer_login'
    end
    request.env['HTTPS'] = 'on'
  end

  after do
    Rails.application.reload_routes!
  end

  context 'not logged in' do
    before do
      get :account
    end

    it 'redirects to login when trying to access page requiring authentication' do
      expect(response).to redirect_to customer_login_path
    end

    it 'authenticated is false' do
      expect(controller.authenticated?).to be false
    end

    it 'gets the session id as the user identifier' do
      expect(controller.user_identifier).to eq '123'
    end
  end

  context 'logged in' do
    let(:customer) { double(Customer, email: 'customer@test.com') }
    let(:current_customer_session) do
      current_customer = double(Authentication::CustomerSession)
      allow(current_customer).to receive(:customer)
        .and_return customer
      current_customer
    end

    before do
      controller.current_customer_session = current_customer_session
      get :account
    end

    it 'allows access to pages requiring login' do
      expect(response.status).to eq 200
    end

    it 'authenticated is true' do
      expect(controller.authenticated?).to be true
    end

    it 'gets the email as the user identifier' do
      expect(controller.user_identifier).to eq 'customer@test.com'
    end
  end

end
