Rails.env = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "database_cleaner"
require "support/structure_helper"

class ActiveSupport::TestCase

  include FactoryGirl::Syntax::Methods
  include StructureHelper

  ActiveRecord::Migration.check_pending!

  # DatabaseCleaner setup
  before :each do |test|
    reset_structure_menu_state

    if test.respond_to?(:metadata) && test.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  after :each do
    reset_structure_menu_state
    DatabaseCleaner.clean
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

end

class Capybara::Rails::TestCase
  self.use_transactional_fixtures = false
end
