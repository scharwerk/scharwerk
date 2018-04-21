class AddBuildToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :build, :integer, default: 0, null: false
  end
end
