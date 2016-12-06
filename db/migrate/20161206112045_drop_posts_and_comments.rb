class DropPostsAndComments < ActiveRecord::Migration
  def change
  	drop_table :comments
  	drop_table :posts
  end
end
