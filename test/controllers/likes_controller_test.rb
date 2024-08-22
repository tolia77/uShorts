require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @account_basic1 = accounts(:basic1)
    @account_basic2 = accounts(:basic2)
    @account_admin1 = accounts(:admin1)
    @profile_basic1 = profiles(:basic1)
    @profile_basic2 = profiles(:basic2)
    @video1 = videos(:one)
    @like = likes(:one)
  end
  test "should like video" do
    assert_difference('Like.count') do
      post likes_url, params: {profile_id: @profile_basic2.id, video_id: @video1.id}, headers: auth_headers(@account_basic2)
    end
    assert_response :created
  end
  test "should not like video second time" do
    post likes_url, params: {profile_id: @profile_basic1.id, video_id: @video1.id}, headers: auth_headers(@account_basic1)
    assert_response :unprocessable_entity
  end
  test "should unlike" do
    assert_difference('Like.count', -1) do
      delete like_url, params: {profile_id: @profile_basic1.id, video_id: @video1.id}, headers: auth_headers(@account_basic1)
    end
    assert_response :no_content
  end
end
