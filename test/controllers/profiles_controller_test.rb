require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @basic1 = profiles(:basic1)
    @account_basic1 = accounts(:basic1)
    @account_basic2 = accounts(:basic2)
    @account_basic3 = accounts(:basic3)
    @account_admin1 = accounts(:admin1)
  end

  test "should get index" do
    get profiles_url, headers: auth_headers(@account_admin1), as: :json
    assert_response :success
  end

  test "should create profile" do
    assert_difference("Profile.count") do
      post profiles_url, params: { profile: { description: @basic1.description, name: @basic1.name, account_id: @account_basic3.id } },
           headers: auth_headers(@account_basic3), as: :json
    end
    assert_response :created
  end

  test "should not create profile without authorization" do
    post profiles_url, params: { profile: { description: @basic1.description, name: @basic1.name, account_id: @account_basic3.id } }, as: :json
    assert_response :unauthorized
  end

  test "should not create second profile" do
    post profiles_url, params: { profile: { description: @basic1.description, name: @basic1.name, account_id: @account_basic1.id } },
           headers: auth_headers(@account_basic1), as: :json
    assert_response :conflict
  end

  test "should show profile" do
    get profile_url(@basic1), as: :json
    assert_response :success
  end

  test "should update profile" do
    patch profile_url(@basic1), params: { profile: { description: @basic1.description, name: @basic1.name } },
          headers: auth_headers(@account_basic1), as: :json
    assert_response :success
  end

  test "should not update profile using different account" do
    patch profile_url(@basic1), params: { profile: { description: @basic1.description, name: @basic1.name } },
          headers: auth_headers(@account_basic2), as: :json
    assert_response :forbidden
  end

  test "should update profile as an admin" do
    patch profile_url(@basic1), params: { profile: { description: @basic1.description, name: @basic1.name } },
          headers: auth_headers(@account_admin1), as: :json
    assert_response :success
  end

  test "should destroy profile" do
    assert_difference("Profile.count", -1) do
      delete profile_url(@basic1),
             headers: auth_headers(@account_basic1), as: :json
    end

    assert_response :no_content
  end

  test "should not destroy profile using different account" do
    delete profile_url(@basic1),
             headers: auth_headers(@account_basic2), as: :json
    assert_response :forbidden
  end

  test "should destroy profile as an admin" do
    assert_difference("Profile.count", -1) do
      delete profile_url(@basic1),
             headers: auth_headers(@account_admin1), as: :json
    end

    assert_response :no_content
  end

end