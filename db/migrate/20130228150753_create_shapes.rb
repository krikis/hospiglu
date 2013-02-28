class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.text :properties

      t.timestamps
    end
  end
end
