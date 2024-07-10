require "test_helper"

class FollowTest < ActiveSupport::TestCase
  def setup
    @profile1 = profiles(:basic1)
    @profile2 = profiles(:basic2)
  end

  test 'should follow profile and add to followees' do
    @profile2.follow(@profile1.id)
    assert @profile2.followees.include?(@profile1)
  end

  test 'should follow profile and add to followers' do
    @profile2.follow(@profile1.id)
    assert @profile1.followers.include?(@profile2)
  end

  test 'should not follow profile second time' do
    assert_not @profile1.follow(@profile2.id)
  end

  test 'should not follow itself' do
    assert_not @profile1.follow(@profile1.id)
  end
end
