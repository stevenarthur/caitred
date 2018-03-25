require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

require "sprockets/railtie"
require 'bootstrap-sass'
require 'authlogic'
require 'judge'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cake
  class Application < Rails::Application
    config.autoload_paths << "#{config.root}/lib"
    config.generators.template_engine :erb
    config.time_zone = 'Sydney'
    config.exceptions_app = routes
    config.youchews_email_to_address = ENV['WEBSITE_TO_EMAIL']
    config.youchews_email_from_address = ENV['WEBSITE_FROM_EMAIL']
    config.youchews_email_name = "Iris at Caitre'd"
    config.supplier_from_email_address = ENV['SUPPLIER_FROM_EMAIL']
    config.supplier_from_email_name = 'Iris'
    config.active_record.schema_format = :sql
    config.active_record.raise_in_transactional_callbacks = true
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
    config.skylight.environments += ['staging']

    # Rack CORS
    config.middleware.insert_before 0, "Rack::Cors",
      :debug => true, :logger => (-> { Rails.logger }) do

      allow do
        origins '*'

        resource '*',
          :headers => :any,
          :methods => [:get, :post, :delete, :put, :patch, :options, :head],
          :max_age => 0
      end
    end
  end
end
