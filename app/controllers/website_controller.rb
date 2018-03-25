class WebsiteController < ApplicationController
  include Web::AuthenticationHandler
  helper_method :current_customer
  helper_method :authenticated?
  helper_method :require_logged_in_customer
  
  before_action :set_location


  layout 'website'

  def set_location
    @location = Location.find_by_slug(params[:location])
  end

  def query_string
    return '' if request.query_string.blank?
    "?#{request.query_string}"
  end

  def current_enquiry
    begin
      if !session[:enquiry_id].nil?
        Enquiry.find(session[:enquiry_id])
      else
        Enquiry.new
      end
    rescue ActiveRecord::RecordNotFound
      Enquiry.new
    end
  end
  helper_method :current_enquiry
  
  def ssl_configured?
    !Rails.env.development?
  end

end
