class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
          :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # validate password strength
  validate :password_strength

  private

  def password_strength
    return if password.blank?

    min_length = Devise.password_length.min
    if password.length < min_length
      errors.add(:password, "must be at least 8 characters long")
    end

    unless password.match?(/[A-Z]/)
      errors.add(:password, "must contain at least one uppercase letter")
    end

    unless password.match?(/[a-z]/)
      errors.add(:password, "must contain at least one lowercase letter")
    end

    unless password.match?(/\d/)
      errors.add(:password, "must contain at least one number")
    end

    unless password.match?(/[!@#$%^&*(),.?":{}|<>]/)
      errors.add(:password, "must contain at least one special character")
    end
  end
end
