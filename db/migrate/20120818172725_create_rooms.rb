class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :slug, null: false

      t.timestamps
    end

    add_index :rooms, :slug, unique: true 
  end
end
