class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :graffle_id
      t.integer :menu_id
      t.integer :start_shape_id
      t.integer :end_shape_id
      t.text :properties

      t.timestamps
    end
  end
end
