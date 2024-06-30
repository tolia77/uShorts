require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
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
    post auth_login_url, params: {email: "one@test.com", password: "password"}
    assert_response :accepted
  end

  test "should not log in with wrong password" do
    post auth_login_url, params: {email: "one@test.com", password: "passwordWrong"}
    assert_response :unauthorized
  end

  test "should return not found when account does not exist" do
    post auth_login_url, params: {email: "notexist@test.com", password: "password"}
    assert_response :not_found
  end

end
