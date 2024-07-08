class Account < ApplicationRecord
  has_secure_password
  attr_reader :password
  has_one :profile, dependent: :destroy
  validates :email, uniqueness: true, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email"}
  validates :password, presence: true, length: { minimum: 6 }
  enum role: %i[basic admin moderator]

  def is_admin?
    self.role == "admin"
  end

  def is_moderator?
    self.role == "moderator" || self.role == "admin"
  end

  def is_owner(object)
    object.account == self || self.is_admin?
  end
end
