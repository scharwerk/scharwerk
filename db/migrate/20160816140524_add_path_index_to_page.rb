class AddPathIndexToPage < ActiveRecord::Migration
  def change
  	add_index(:pages, :path, unique: true)
  end
end
