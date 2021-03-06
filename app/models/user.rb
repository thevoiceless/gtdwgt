# == Schema Information
#
# Table name: users
#
#  id                                :integer          not null, primary key
#  email                             :string(255)
#  password_digest                   :string(255)
#  created_at                        :datetime
#  updated_at                        :datetime
#  remember_token                    :string(255)
#  photo_file_name                   :string(255)
#  photo_content_type                :string(255)
#  photo_file_size                   :integer
#  photo_updated_at                  :datetime
#  encrypted_access_token            :string(255)
#  encrypted_access_token_salt       :string(255)
#  encrypted_access_token_iv         :string(255)
#  g_email                           :string(255)
#  g_name                            :string(255)
#  encrypted_authorization_code      :string(255)
#  encrypted_authorization_code_salt :string(255)
#  encrypted_authorization_code_iv   :string(255)
#

class User < ActiveRecord::Base  
  attr_accessible :email, :password, :password_confirmation, :photo, :delete_photo, :authorization_code, :access_token, :g_name, :g_email
  attr_accessor :delete_photo
  attr_encrypted :authorization_code, key: 'IBEwvHFjRbvPL+/qhefJGAe/'
  attr_encrypted :access_token, key: 'CQIoUQRROXeHbicBunrvZw2S'
  has_secure_password
  has_attached_file :photo, path: "cs446/moses/#{Rails.env}:url", styles: { medium: "300x300>", small: "100x100>", tiny: "30x30>" }, default_url: "/images/:style/profile_default.png"

  # Convert entire email address to lowercase before saving it to the database
  # Although the standard states that the local part of the address is case-sensitive, uniequeness is enforced at the database level
  # This is done using an index, but not all database adapters use case-sensitive indices
  # In practice, the general consensus seems to be that capitalization does not usually cause issues
  before_save { |user| user.email.downcase! }
  before_save :create_remember_token
  # http://stackoverflow.com/questions/4435826/rails-paperclip-how-to-delete-attachment
  before_save :delete_photo!

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[A-Za-z\d\-.]+\.[A-Za-z]+\z/i

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 8 }
  validates :password_confirmation, presence: true

  def authorized_api?
    self.authorization_code and self.access_token
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def delete_photo!
      self.photo = nil if self.delete_photo == "1"
    end
end
