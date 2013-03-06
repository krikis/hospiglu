class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :session_id
      t.text :properties

      t.timestamps
    end
  end
end
