# encoding: UTF-8

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    unless Rails.env.development? || Rails.env.cucumber? || Rails.env.test?
      rescue_from StandardError do |exception|
        logger.error exception.message
        logger.error exception.backtrace
        Bugsnag.auto_notify($!)
        render template: 'errors/internal_error', status: 500, layout: 'website'
      end

      rescue_from ActionController::RoutingError do
        Bugsnag.auto_notify($!)
        render template: 'errors/not_found', status: 404, layout: 'website'
      end

      rescue_from ActiveRecord::RecordInvalid do
        Bugsnag.auto_notify($!)
        render template: 'errors/unprocessable_entity', status: 422, layout: 'website'
      end
    end
  end
end
