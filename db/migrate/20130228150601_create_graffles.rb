class CreateGraffles < ActiveRecord::Migration
  def change
    create_table :graffles do |t|
      t.integer :brainstorm_id
      t.integer :user_id
      t.text :properties

      t.timestamps
    end
  end
end
