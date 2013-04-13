# == Schema Information
#
# Table name: users
#
#  id                                :integer          not null, primary key
#  email                             :string(255)
#  password_digest                   :string(255)
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  remember_token                    :string(255)
#  photo_file_name                   :string(255)
#  photo_content_type                :string(255)
#  photo_file_size                   :integer
#  photo_updated_at                  :datetime
#  encrypted_authorization_code      :string(255)
#  encrypted_authorization_code_salt :string(255)
#  encrypted_authorization_code_iv   :string(255)
#  g_email                           :string(255)
#  g_name                            :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
