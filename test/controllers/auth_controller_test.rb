require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @basic_one = accounts(:basic1)
  end
  test "should sign up" do
    post auth_signup_url, params: {email: "test1@test.com", password: "1234567890"}
    assert_response :created
  end

  test "should not sign up with invalid email" do
    post auth_signup_url, params: {email: "invalidEmail", password: "1234567890"}
    assert_response :unprocessable_entity
  end

  test "should not sign up with invalid password" do
    post auth_signup_url, params: {email: "test1@test.com", password: "bad"}
    assert_response :unprocessable_entity
  end

  test "should log in" do
    post auth_login_url, params: {email: @basic_one.email, password: "password"}
    assert_response :accepted
  end

  test "should not log in with wrong password" do
    post auth_login_url, params: {email: @basic_one.email, password: "passwordWrong"}
    assert_response :unauthorized
  end

  test "should return not found when account does not exist" do
    post auth_login_url, params: {email: "notexist@test.com", password: "password"}
    assert_response :not_found
  end

  test 'should refresh token' do
    get refresh_url, headers: auth_headers_refresh(@basic_one)
    assert_response :accepted
  end

  test 'should not allow to refresh with block list jti' do
    get refresh_url, headers: auth_headers_refresh(@basic_one, sessions(:one).jti)
    assert_response :unauthorized
  end

end
