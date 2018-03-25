# encoding: UTF-8

class ApplicationController < ActionController::Base
  include ErrorHandler
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl unless: :development_or_testing?

  def development_or_testing?
    Rails.env.development? || Rails.env.test?
  end

end
