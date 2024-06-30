class Account < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email"}
end
