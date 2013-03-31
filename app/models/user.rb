# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)
#  password_digest    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  remember_token     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :photo, :delete_photo
  attr_accessor :delete_photo
  has_secure_password
  has_attached_file :photo, styles: { medium: "300x300>", small: "100x100>", tiny: "30x30>" }, default_url: "/images/:style/profile_default.png"

  # Convert email address to lowercase before saving it to the database so that the uniqueness constraint
  # used by the index is guaranteed to work correctly
  # Explanation for this caveat can be found at http://ruby.railstutorial.org/chapters/modeling-users#sec-uniqueness_validation
  # TODO: Only store domain as lowercase; everything before the '@' is case-sensitive according to the standard
  # See http://email.about.com/od/emailbehindthescenes/f/email_case_sens.htm
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  # http://stackoverflow.com/questions/4435826/rails-paperclip-how-to-delete-attachment
  before_save :delete_photo?

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@gmail.com\z/i

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 8 }
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def delete_photo?
      self.photo = nil if self.delete_photo == "1"
    end
end
