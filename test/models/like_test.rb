require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup
    @profile1 = profiles(:basic1)
    @profile2 = profiles(:basic2)
    @video1 = videos(:one)
  end

  test 'should like video' do
    like = Like.new(profile_id: @profile2.id, video_id: @video1.id)
    assert like.save
    assert @profile2.liked_videos.include?(@video1)
    assert @video1.likes_profiles.include?(@profile2)
  end

  test 'should not like second time' do
    like = Like.new(profile_id: @profile1.id, video_id: @video1.id)
    assert_not like.save
  end
end
