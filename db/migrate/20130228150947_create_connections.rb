class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.text :properties

      t.timestamps
    end
  end
end
