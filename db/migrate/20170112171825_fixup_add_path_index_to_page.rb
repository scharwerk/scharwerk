require_relative '20160816140524_add_path_index_to_page'

class FixupAddPathIndexToPage < ActiveRecord::Migration
  def change
  	revert AddPathIndexToPage

  	add_index(:pages, :path)
  end
end
