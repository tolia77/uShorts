class Profile < ApplicationRecord
  belongs_to :account
  validates :name, presence: true, length: {maximum: 32}
  validates :description, length: {maximum: 200}
end
