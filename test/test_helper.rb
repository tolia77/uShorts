ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include AuthHelper
  # Run tests in parallel with specified workers
  #parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def auth_headers(account)
    {"Authorization": "Bearer #{jwt_encode(account.id)}"}
  end

  def auth_headers_refresh(account, jti=generate_jti)
    {"Authorization": "Bearer #{jwt_encode_refresh(account.id, jti)}"}
  end

end
