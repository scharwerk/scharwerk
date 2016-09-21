class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :status
      t.integer :stage
      t.integer :part
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
