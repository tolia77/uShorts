require "test_helper"

class FollowsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @account_basic1 = accounts(:basic1)
    @account_basic2 = accounts(:basic2)
    @account_admin1 = accounts(:admin1)
    @profile_basic1 = profiles(:basic1)
    @profile_basic2 = profiles(:basic2)
    @follow = follows(:one_two)
  end

  test "should follow" do
    assert_difference('Follow.count') do
      post follows_path, params: {follow: {follower_id: @profile_basic2.id, followee_id: @profile_basic1.id }},
           headers: auth_headers(@account_basic2), as: :json
    end

    assert_response :created
  end

  test 'should not follow as other user' do
    post follows_path, params: {follow: {follower_id: @profile_basic2.id, followee_id: @profile_basic1.id }},
         headers: auth_headers(@account_basic1), as: :json
    assert_response :forbidden
  end

  test 'should not follow second time' do
    post follows_path, params: {follow: {follower_id: @profile_basic1.id, followee_id: @profile_basic2.id }},
         headers: auth_headers(@account_basic1), as: :json
    assert_response :unprocessable_entity
  end

  test 'should follow any account as admin' do
    assert_difference('Follow.count') do
      post follows_path, params: {follow: {follower_id: @profile_basic2.id, followee_id: @profile_basic1.id }},
           headers: auth_headers(@account_admin1), as: :json
    end

    assert_response :created
  end

  test 'should not follow when not found' do
    post follows_path, params: {follow: {follower_id: 124214241, followee_id: 35321521 }},
         headers: auth_headers(@account_basic1), as: :json
    assert_response :unprocessable_entity
  end

  test "should unfollow" do
    assert_difference('Follow.count', -1) do
      delete follow_path, params: {follow: {follower_id: @profile_basic1.id, followee_id: @profile_basic2.id }},
             headers: auth_headers(@account_basic1), as: :json
    end

    assert_response :success
  end

  test "should not unfollow as other user" do
    delete follow_path, params: {follow: {follower_id: @profile_basic1.id, followee_id: @profile_basic2.id }},
           headers: auth_headers(@account_basic2), as: :json

    assert_response :forbidden
  end

  test "should not unfollow when not found" do
    delete follow_path, params: {follow: {follower_id: 12344234, followee_id: 23151325 }},
           headers: auth_headers(@account_basic2), as: :json

    assert_response :not_found
  end
end
