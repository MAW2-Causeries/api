ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "json"
require "devise"

module SecureRandom
  class << self
    unless method_defined?(:id)
      def id
        uuid
      end
    end
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def json_body
      ::JSON.parse(response.body)
    end

    def assert_json_error(code:, message:)
      assert_equal code, json_body.dig("error", "code")
      assert_equal message, json_body.dig("error", "message")
    end
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
