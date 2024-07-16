require "test_helper"

class VideoTest < ActiveSupport::TestCase
  def setup
    @video_one = videos(:one)
    @profile1 = profiles(:basic1)
  end

  test 'should have source' do
    assert @video_one.source.attached?
  end

  test 'should not allow attaching wrong file' do
    @video = @profile1.videos.build
    file = Rails.root.join('test', 'fixtures', 'files', 'snoop.jpg')
    @video.source.attach(io: File.open(file), filename: 'snoop.jpg')
    assert_not @video.save
  end

  test 'should allow attaching file' do
    @video2 = @profile1.videos.build
    file = Rails.root.join('test', 'fixtures', 'files', 'minecraft2.mp4')
    @video2.source.attach(io: File.open(file), filename: 'minecraft2.mp4')
    assert @video2.save
  end

  test 'should not change source' do
    file = Rails.root.join('test', 'fixtures', 'files', 'minecraft2.mp4')
    @video_one.source.attach(io: File.open(file), filename: 'minecraft2.mp4')
    assert_not @video_one.save
  end
end
