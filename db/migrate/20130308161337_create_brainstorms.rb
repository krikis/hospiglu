class CreateBrainstorms < ActiveRecord::Migration
  def change
    create_table :brainstorms do |t|
      t.text :properties
      t.string :state, default: 'open'
      t.string :phase

      t.timestamps
    end
  end
end
