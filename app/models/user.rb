# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password

  # Convert email address to lowercase before saving it to the database so that the uniqueness constraint
  # used by the index is guaranteed to work correctly
  # Explanation for this caveat can be found at http://ruby.railstutorial.org/chapters/modeling-users#sec-uniqueness_validation
  # TODO: Only store domain as lowercase; everything before the '@' is case-sensitive according to the standard
  # See http://email.about.com/od/emailbehindthescenes/f/email_case_sens.htm
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@gmail.com\z/i

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 8 }
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
