class Profile < ApplicationRecord
  belongs_to :account

  has_many :followers_follow, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :followers_follow, source: :follower

  has_many :followees_follow, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followees, through: :followees_follow, source: :followee

  has_many :videos, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_videos, through: :likes, source: :video

  has_one_attached :avatar

  validates :name, presence: true, length: {maximum: 32}
  validates :description, length: {maximum: 200}

  validate do
    if self.avatar.attached? && !self.avatar.content_type.in?(%w(image/png image/jpeg image/webp))
      errors.add(:avatar, 'Must be PNG or JPEG')
    end
  end

  before_validation :check_has_profile, on: :create

  def check_has_profile
    if Profile.find_by(account_id: self.account_id)
      self.errors.add(:account_id, "This account already has a profile")
    end
  end

  def follow(id)
    f = Follow.new(follower_id: self.id, followee_id: id)
    return f.save
  end

  def unfollow(id)
    f = Follow.find_by(follower_id: self.id, followee_id: id)
    return f.destroy
  end
end
