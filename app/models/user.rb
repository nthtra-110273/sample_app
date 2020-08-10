class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.user.email.regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true,
    length: {maximum: Settings.validations.user.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.validations.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            allow_nil: true,
    length: {minimum: Settings.validations.user.password.min_length}

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  has_secure_password

  def forget
    update remember_digest: nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_mail_activate
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  private

  def downcase_email
    email.downcase!
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
