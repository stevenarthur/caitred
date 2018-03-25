require 'rails_helper'

class TestErrorController < ApplicationController
  def ssl_required
    false
  end

  def raises_not_found
    fail ActionController::RoutingError, 'testing'
  end

  def raises_internal_error
    fail StandardError, 'testing'
  end

  def raises_unprocessable
    Enquiry.new.save!
  end
end

describe TestErrorController, type: :controller do

  before do
    Rails.application.routes.draw do
      get :raises_not_found, to: 'test_error#raises_not_found'
      get :raises_internal_error, to: 'test_error#raises_internal_error'
      get :raises_unprocessable, to: 'test_error#raises_unprocessable'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe '404' do
    before do
      get :raises_not_found
    end

    pending'renders the 404 template' do
      expect(response).to have_rendered 'not_found'
    end

    #it_behaves_like 'not found'
  end

  describe '500' do
    before do
      get :raises_internal_error
    end

    pending'renders the 500 template' do
      expect(response).to have_rendered 'internal_error'
    end

    #it_behaves_like 'returns an error'
  end

  describe '422' do
    before do
      get :raises_unprocessable
    end

    pending'renders the 422 template' do
      expect(response).to have_rendered 'unprocessable_entity'
    end

    #it_behaves_like 'unprocessable entity'
  end

end
