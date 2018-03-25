source 'https://rubygems.org'
ruby "2.3.3"

gem 'rails', '~> 4.2'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

gem 'reform'
gem 'simple_form'
gem 'judge', git: 'https://github.com/joecorcoran/judge' 
gem 'judge-simple_form'
gem 'friendly_id'

gem 'font-awesome-rails'
gem 'dotenv'
gem 'excon'
gem 'premailer-rails'
gem 'nokogiri'

gem 'akismet' # comment spam

gem 'bugsnag'
gem 'ruby-trello'
gem 'dalli'

gem 'rack-cors', :require => 'rack/cors'
gem 'rack-canonical-host'

group :doc do
  gem 'sdoc', require: false
end

gem 'haml'
gem 'rails_12factor', group: :production
gem 'bootstrap-sass', '3.1.1.1'
gem 'authlogic', '3.4.6'
gem 'scrypt'
gem 'bcrypt'
gem 'business_time'
gem 'faraday'
gem 'mobylette'
gem 'xeroizer'
#Upload Images
gem 'carrierwave'
gem 'mini_magick'
gem 'fog-aws'
gem 'gibbon', '~> 1.0'
#send SMS
gem 'telstra-sms'
gem 'sidekiq'
gem 'sinatra', :require => nil
gem 'puma'
gem 'redis'
#Payment
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'aws-sdk', '~> 2'

gem 'skylight'

# Papertrail Stuff
gem 'paper_trail'
gem 'paper_trail-globalid'

gem 'net-ssh'
gem 'httparty'


group :development do
  gem 'rails-erd', require: false
  gem 'quiet_assets', require: false
  gem 'bullet'
  gem 'derailed', require: false
  gem 'sexp_processor', require: false
  gem 'ruby_parser', require: false
  gem 'flog', '4.2.1', git: 'https://github.com/YouChews/flog', require: false
  gem 'flay', '2.5.0', git: 'https://github.com/YouChews/flay', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'jasmine-rails'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  # Interact with errors
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bundler-audit', require: false
end

group :test do
  gem 'simplecov', '~> 0.7.1', require: false
  gem 'rspec-rails'
  gem 'pry'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'capybara'
  gem 'poltergeist', git: 'https://github.com/teampoltergeist/poltergeist'
  gem 'rubocop', require: false
  gem 'timecop'
  gem 'capybara-screenshot'
  gem 'therubyracer'
  gem 'execjs'
end

group :production do
  gem 'newrelic_rpm'
  gem 'puma_worker_killer'
end

