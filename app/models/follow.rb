class Follow < ApplicationRecord
  belongs_to :followee, foreign_key: :followee_id, class_name: 'Profile'
  belongs_to :follower, foreign_key: :follower_id, class_name: 'Profile'
  validates :follower_id, presence: true
  validates :followee_id, presence: true
  validate do
    if self.follower_id == self.followee_id
      self.errors.add(:base, "Can not follow yourself")
    end
    if Follow.find_by(follower_id: self.follower_id, followee_id: self.followee_id)
      self.errors.add(:base, "Can not follow second time")
    end
  end
end
