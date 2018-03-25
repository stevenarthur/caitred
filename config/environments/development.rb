Cake::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  #config.logger = Logger.new(STDOUT)

  config.assets.debug = false
  config.assets.logger = false

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
  end
end

Rails.application.routes.default_url_options[:host] = ENV["DEFAULT_HOST"]
