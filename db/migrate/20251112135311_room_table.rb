class RoomTable < ActiveRecord::Migration[8.1]
  def change
      create_table :rooms do |t|
        t.belongs_to :type, null: false, foreign_key: { to_table: :roomTypes }
        t.string :description, null: true
        t.belongs_to :guild, null: false, foreign_key: { to_table: :guilds }
      t.timestamps
    end
  end
end
