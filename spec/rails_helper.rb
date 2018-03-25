# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require "authlogic/test_case"

require 'factory_girl'
require 'factories'
require 'database_cleaner'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    inspector: true
  })
end

DEFAULT_HOST = "lvh.me"
DEFAULT_PORT = 9887
Capybara.default_host = "http://#{DEFAULT_HOST}"
Capybara.server_port = DEFAULT_PORT
Capybara.app_host = "http://#{DEFAULT_HOST}:#{Capybara.server_port}"
Capybara.default_max_wait_time = 30

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include ActiveJob::TestHelper 
  config.include Authlogic::TestCase
  config.include WaitForAjax, type: :feature
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
end
