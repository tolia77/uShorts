require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest

  test 'should not get protected page when token expires' do
    headers_exp = {"Authorization": "Bearer #{jwt_encode(accounts(:basic1).id, Time.now.to_i - 200)}"}
    get pages_protected_url, headers: headers_exp
    assert_response :unauthorized
  end
end
