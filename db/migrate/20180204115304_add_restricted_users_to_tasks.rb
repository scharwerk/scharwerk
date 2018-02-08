require_relative '20180107172830_add_restricted_user_to_tasks'

class AddRestrictedUsersToTasks < ActiveRecord::Migration
  def up
    revert AddRestrictedUserToTasks

    create_table :restrictions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :task, index: true
    end

  end

  def down
    drop_table :restrictions

    run AddRestrictedUserToTasks
  end
end
