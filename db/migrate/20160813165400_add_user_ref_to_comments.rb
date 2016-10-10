# add top class documentation
class AddUserRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :user, index: true, foreign_key: true
  end
end
