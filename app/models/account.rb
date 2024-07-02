class Account < ApplicationRecord
  has_secure_password
  attr_reader :password
  validates :email, uniqueness: true, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email"}
  validates :password, presence: true, length: { minimum: 6 }
  enum role: %i[basic admin moderator]

  def is_admin?
    self.role == 1
  end
end
