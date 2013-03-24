# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :password_digest

  # Convert email address to lowercase before saving it to the database so that the uniqueness constraint
  # used by the index is guaranteed to work correctly
  # Explanation for this caveat can be found at http://ruby.railstutorial.org/chapters/modeling-users#sec-uniqueness_validation
  before_save { |user| user.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@gmail.com\z/i

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  has_secure_password
end
