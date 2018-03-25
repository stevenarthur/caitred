Cake::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_files = true
  config.force_ssl = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'
  config.log_level = :info
  config.logger = Logger.new(STDOUT)
  config.active_record.schema_format = :ruby
  config.active_job.queue_adapter = :sidekiq
  config.assets.precompile << proc do |path|
    if path =~ /\.(css|js)\z/
      full_path = Rails.application.assets.resolve(path).to_path
      app_assets_path = Rails.root.join('app', 'assets').to_path
      if full_path.starts_with? app_assets_path
        true
      else
        false
      end
    else
      false
    end
  end
  config.assets.precompile += %w( website.js )

  config.action_controller.asset_host = "d1y39etuwtcmhu.cloudfront.net"
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  config.action_mailer.asset_host = 'http://d1y39etuwtcmhu.cloudfront.net'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address => "email-smtp.us-west-2.amazonaws.com",
      :port => 587, # Port 25 is throttled on AWS
      :user_name => ENV["AWS_SES_USERNAME"], # Your SMTP user here.
      :password => ENV["AWS_SES_PASSWORD"], # Your SMTP password here.
      :authentication => :login,
      :enable_starttls_auto => true
  }

  #if ENV["MEMCACHEDCLOUD_SERVERS"]
    #config.cache_store = :dalli_store, 
      #ENV["MEMCACHEDCLOUD_SERVERS"].split(','), { :username => ENV["MEMCACHEDCLOUD_USERNAME"], :password => ENV["MEMCACHEDCLOUD_PASSWORD"] }
  #end
  
end
Rails.application.routes.default_url_options[:host] = ENV["DEFAULT_HOST"]
