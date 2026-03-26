class RoomTable < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms, id: false do |t|
      t.string :id, primary_key: true
      t.string :room_type_id, null: false
      t.string :description, null: true
      t.string :guild_id, null: false
      t.timestamps
    end

    add_foreign_key :rooms, :guilds, column: :guild_id
    add_foreign_key :rooms, :roomTypes, column: :room_type_id
  end
end
