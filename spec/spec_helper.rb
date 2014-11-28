# http://viget.com/extend/rails-engine-testing-with-rspec-capybara-and-factorygirl
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'capybara'
require 'capybara/poltergeist'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end

Capybara.javascript_driver = :poltergeist


### Share the DB connection so poltergeist can run
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection||retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
