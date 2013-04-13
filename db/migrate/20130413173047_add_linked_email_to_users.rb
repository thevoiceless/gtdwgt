class AddLinkedEmailToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :linked_email, :string
  end
end
