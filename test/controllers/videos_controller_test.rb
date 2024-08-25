require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  def setup
    @video1 = videos(:one)
    @account_basic1 = accounts(:basic1)
    @account_basic2 = accounts(:basic2)
    @account_basic3 = accounts(:basic3)
    @account_moderator1 = accounts(:moderator1)
    @account_admin1 = accounts(:admin1)
  end

  test 'should get index' do
    get videos_url
    assert_response :success
  end

  test 'should search video' do
    get videos_search_url, params: {key: "on", page: 1}
    assert_response :success
  end

  test 'should show video' do
    get video_url(@video1)
    assert_response :success
  end

  test 'should upload video' do
    assert_difference('Video.count') do
      post videos_url, params: {
        video: {
          description: "idk",
          source: fixture_file_upload("minecraft2.mp4", "video/mp4")
        }
      }, headers: auth_headers(@account_basic1)
    end
    assert_response :created
  end

  test 'should require authorization to upload video' do
    post videos_url, params: {
      video: {
        description: "idk",
        source: fixture_file_upload("minecraft2.mp4", "video/mp4")
      }
    }
    assert_response :unauthorized
  end

  test 'should update video' do
    patch video_url(@video1), params: {
      video: {
        description: "idkkkkk"
      }
    }, headers: auth_headers(@account_basic1)
    assert_response :success
  end

  test 'should update video as moderator' do
    patch video_url(@video1), params: {
      video: {
        description: "idkkkkk"
      }
    }, headers: auth_headers(@account_moderator1)
    assert_response :success
  end

  test 'should not update video as other user' do
    patch video_url(@video1), params: {
      video: {
        description: "idkkkkk"
      }
    }, headers: auth_headers(@account_basic2)
    assert_response :forbidden
  end

  test 'should delete video' do
    assert_difference('Video.count', -1) do
      delete video_url(@video1), headers: auth_headers(@account_basic1)
    end
    assert_response :no_content
  end

  test 'should delete video as moderator' do
    assert_difference('Video.count', -1) do
      delete video_url(@video1), headers: auth_headers(@account_moderator1)
    end
    assert_response :no_content
  end



end
