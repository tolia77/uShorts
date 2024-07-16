class Video < ApplicationRecord
  belongs_to :profile
  has_one_attached :source
  validates :description, length: {maximum: 200}
  validates :source, presence: true
  validate do
    unless self.source.content_type == "video/mp4"
      self.errors.add(:source, "Source must be .mp4")
    end
  end
  validate do
    if self.source.changed? && self.persisted?
      self.errors.add(:source, "Source can't be changed")
    end
  end
end
