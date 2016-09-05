class AddFbToUsers < ActiveRecord::Migration
  def change
	## Database authenticatable
	remove_column :users, :email
	remove_column :users, :encrypted_password

	## Recoverable
	remove_column :users, :reset_password_token
	remove_column :users, :reset_password_sent_at

	add_column :users, :name, :string
	add_column :users, :facebook_id, :string
	add_column :users, :facebook_data, :text

	add_index :users, :facebook_id, unique: true
  end
end
