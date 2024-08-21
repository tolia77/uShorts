class Session < ApplicationRecord
  belongs_to :account
  validates :account_id, presence: true
  validates :jti, presence: true, uniqueness: true
end
