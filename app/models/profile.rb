class Profile < ApplicationRecord
  belongs_to :account

  has_many :followers_follow, foreign_key: :followee_id, class_name: 'Follow'
  has_many :followers, through: :followers_follow, source: :follower

  has_many :followees_follow, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followees, through: :followees_follow, source: :followee

  validates :name, presence: true, length: {maximum: 32}
  validates :description, length: {maximum: 200}

  def follow(id)
    Follow.create!(follower_id: self.id, followee_id: id)
  end
end
