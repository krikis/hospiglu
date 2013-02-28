class CreateGraffles < ActiveRecord::Migration
  def change
    create_table :graffles do |t|

      t.timestamps
    end
  end
end
