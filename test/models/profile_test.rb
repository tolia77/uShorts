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

  test 'should not attach avatar with wrong format' do
    file = Rails.root.join('test', 'fixtures', 'files', 'minecraft1.mp4')
    @profile_basic1.avatar.attach(io: File.open(file), filename: 'minecraft1.mp4')
    assert_not @profile_basic1.save
  end
end
