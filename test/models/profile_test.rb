require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  def setup
    @account_basic1 = accounts(:basic1)
    @profile_basic1 = profiles(:basic1)
  end
  test 'should not create second profile' do
    p = Profile.new(name: "test1122112", account_id: @account_basic1.id)
    assert_not p.save
  end

  test 'should have an avatar' do
    assert @profile_basic1.avatar.attached?
  end
end
