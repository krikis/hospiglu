class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.integer :graffle_id
      t.boolean :in_menu, default: false
      t.text :properties

      t.timestamps
    end
  end
end
