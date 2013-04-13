class AddGoogleInfoToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :g_email, :string
  	add_column :users, :g_name, :string
  end
end
