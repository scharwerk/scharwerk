require_relative '20180107172830_add_restricted_user_to_tasks'

class AddRestrictedUsersToTasks < ActiveRecord::Migration
  def up
    create_table :restrictions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :task, index: true
    end

    Task.all.each do |task|
      if !task.restricted_user_id.nil?
        restriction = Restriction.new
        restriction.task_id = task.id
        restriction.user_id = task.restricted_user_id
        restriction.save
      end
    end

    revert AddRestrictedUserToTasks
  end

  def down
    drop_table :restrictions

    run AddRestrictedUserToTasks
  end
end
