class Like < ApplicationRecord
  belongs_to :profile
  belongs_to :video
  validate do
    if Like.find_by(profile_id: self.profile.id, video_id: self.video.id)
      self.errors.add(:base, 'can not like video second time')
    end
  end
end
