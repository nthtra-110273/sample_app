class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.user.email.regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {maximum: Settings.validations.user.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.validations.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.validations.user.password.min_length}

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
