Rails.env = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "database_cleaner"

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase

  include FactoryGirl::Syntax::Methods

  ActiveRecord::Migration.check_pending!

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  # Add more helper methods to be used by all tests here...

end
