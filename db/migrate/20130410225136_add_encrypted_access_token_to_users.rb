class AddEncryptedAccessTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :encrypted_access_token, :string
  	add_column :users, :encrypted_access_token_salt, :string
  	add_column :users, :encrypted_access_token_iv, :string
  end
end
