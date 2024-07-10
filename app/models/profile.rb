class Profile < ApplicationRecord
  belongs_to :account

  has_many :followers_follow, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :followers_follow, source: :follower, dependent: :destroy

  has_many :followees_follow, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followees, through: :followees_follow, source: :followee, dependent: :destroy
  
  validates :name, presence: true, length: {maximum: 32}
  validates :description, length: {maximum: 200}

  def follow(id)
    f = Follow.new(follower_id: self.id, followee_id: id)
    return f.save
  end

  def unfollow(id)
    f = Follow.find_by(follower_id: self.id, followee_id: id)
    return f.destroy
  end
end
