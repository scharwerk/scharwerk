class AddOrderToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :order, :integer
    add_index :tasks, :order

    Task.all.each { |task| task.update(order: task.id) }
  end
end
