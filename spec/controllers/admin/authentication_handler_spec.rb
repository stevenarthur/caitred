require 'rails_helper'

class WithAuthController < AdminController
  before_filter :require_admin_authentication, only: [:new]
  before_filter :require_power_user, only: [:power]
  attr_accessor :current_user

  def new
    render text: ''
  end

  def power
    render text: ''
  end
end

describe WithAuthController, type: :controller do

  before do
    Rails.application.routes.draw do
      get :new, to: 'with_auth#new'
      get :power, to: 'with_auth#power'
      get :login, to: 'admin_user_sessions#new'
    end
    request.env['HTTPS'] = 'on'
  end

  after do
    Rails.application.reload_routes!
  end

  context 'not logged in' do

    it 'redirects to login when trying to authenticate' do
      get :new
      expect(response).to redirect_to login_path
    end

    it 'redirects to login when requiring power user' do
      get :power
      expect(response).to redirect_to login_path
    end

    it 'authenticated is false' do
      expect(controller.authenticated?).to be false
    end

    it 'power user is false' do
      expect(controller.power_user?).to be false
    end

  end

  context 'logged in' do
    let(:current_user) do
      current_user = double
      allow(current_user).to receive(:is_power_user).and_return(is_power_user)
      current_user
    end

    before do
      controller.current_user = current_user
    end

    context 'not power user' do
      let(:is_power_user) { false }

      it 'does not redirect' do
        get :new
        expect(response).not_to redirect_to login_path
      end

      it 'renders the forbidden template' do
        get :power
        expect(response).to have_rendered('shared/forbidden')
      end

      it 'sets the status to forbidden' do
        get :power
        expect(response.status).to be 403
      end

      it 'authenticated is true' do
        expect(controller.authenticated?).to be true
      end

      it 'power user is false' do
        expect(controller.power_user?).to be false
      end

    end

    context 'power user' do

      let(:is_power_user) { true }

      it 'does not return an error when checking for power user' do
        get :power
        expect(flash[:error]).to be_nil
      end

      it 'authenticated is true' do
        expect(controller.authenticated?).to be true
      end

      it 'power user is true' do
        expect(controller.power_user?).to be true
      end

    end

  end

end
