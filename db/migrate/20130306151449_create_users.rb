class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :brainstorm_id
      t.string :name
      t.text :properties

      t.timestamps
    end
  end
end
