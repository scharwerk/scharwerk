class AddStatusToPage < ActiveRecord::Migration
  def change
  	add_column :pages, :status, :integer
  end
end
