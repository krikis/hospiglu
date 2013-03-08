class CreateBrainstorms < ActiveRecord::Migration
  def change
    create_table :brainstorms do |t|
      t.text :properties
      t.string :state, default: 'open'

      t.timestamps
    end
  end
end
