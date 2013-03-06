class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.text :properties
      t.string :state

      t.timestamps
    end
  end
end
