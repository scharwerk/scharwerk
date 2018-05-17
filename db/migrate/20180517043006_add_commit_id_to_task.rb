class AddCommitIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :commit_id, :string
  end
end
