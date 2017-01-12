class FixNullFields < ActiveRecord::Migration
  def change
    change_column :pages, :status, :integer, default: 0, null: false
    remove_index(:pages, :path)

    change_column :tasks, :status, :integer, default: 0, null: false
    change_column :tasks, :stage, :integer, default: 0, null: false
    change_column :tasks, :part, :integer, default: 0, null: false
  end
end
