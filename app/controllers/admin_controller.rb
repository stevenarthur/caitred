class AdminController < ApplicationController
  include Admin::AuthenticationHandler

  helper_method :current_user
  helper_method :authenticated?
  helper_method :power_user?
  helper_method :current_customer
  layout 'admin'

  def user_for_paper_trail
    authenticated? ? current_user : ''
  end

  def current_customer
    false
  end

end
