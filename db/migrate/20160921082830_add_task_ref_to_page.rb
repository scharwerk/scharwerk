# add top class documentation
class AddTaskRefToPage < ActiveRecord::Migration
  def change
    add_reference :pages, :task, index: true, foreign_key: true
  end
end
