class AddEncryptedAuthorizationCodeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :encrypted_authorization_code, :string
  	add_column :users, :encrypted_authorization_code_salt, :string
  	add_column :users, :encrypted_authorization_code_iv, :string
  end
end
