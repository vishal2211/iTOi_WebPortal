# Start up simplecov immediately before anything else is loaded or required
require 'simplecov'

SimpleCov.start 'rails'
SimpleCov.coverage_dir('public/coverage')

require 'rspec/rails'
require 'support/request_helpers'
require 'capybara/rspec'
require 'capybara/webkit'
require 'support/shared_contexts/rake'

# The default value of time to wait
SLEEP = 0.5

# Make Capybara use webkit
Capybara.javascript_driver = :webkit
# Capybara.javascript_driver = :selenium

# Config Rspec
RSpec.configure do |config|
  config.alias_example_to :with

  config.mock_with :rspec do |configuration|
    configuration.syntax = [:expect, :should]
  end

  config.include Requests::JsonHelpers, :type => :controller
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature # Devise Helpers in feature requests
  config.include FactoryGirl::Syntax::Methods
  config.raise_errors_for_deprecations!

  config.extend Requests::DeviseHelpers, :type => :controller

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed # loading seeds
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# API HELPER
def basic_auth_and_skip_hmac(has_recordings = false)
  if has_recordings
    @user = FactoryGirl.create(:user_with_recordings, password: 'password', password_confirmation: 'password')
  else
    @user = FactoryGirl.create(:user, password: 'password', password_confirmation: 'password')
  end
  request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'password')
end