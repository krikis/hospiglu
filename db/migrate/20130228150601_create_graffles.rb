class CreateGraffles < ActiveRecord::Migration
  def change
    create_table :graffles do |t|
      t.text :properties

      t.timestamps
    end
  end
end
