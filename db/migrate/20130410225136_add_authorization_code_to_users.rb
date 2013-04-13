class AddAuthorizationCodeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :authorization_code, :string
  end
end
