class AddRestrictedUserToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :restricted_user, references: :users, index: true
	add_foreign_key :tasks, :users, column: :restricted_user_id
  end
end
