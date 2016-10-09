# add top class documentation
class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :path
      t.text :text

      t.timestamps null: false
    end
  end
end
