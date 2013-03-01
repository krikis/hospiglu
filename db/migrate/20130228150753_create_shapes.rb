class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.integer :graffle_id
      t.integer :menu_id
      t.text :properties

      t.timestamps
    end
  end
end
