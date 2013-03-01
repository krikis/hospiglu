class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :graffle_id
      t.boolean :in_menu, default: false
      t.integer :start_shape_id
      t.integer :end_shape_id
      t.text :properties

      t.timestamps
    end
  end
end
