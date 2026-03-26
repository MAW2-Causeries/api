class UpdateChannel < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :rooms, column: :room_type_id, if_exists: true
    remove_column :rooms, :room_type_id
    add_column :rooms, :category, :string
    add_column :rooms, :name, :string
    remove_foreign_key :rooms, column: :guild_id, if_exists: true

    rename_table :rooms, :channels
    rename_column :channels, :id, :uuid
    change_column :channels, :uuid, :string, limit: 36

    drop_table :roomtypes
    change_column :guilds, :creator_id, :string, limit: 36
    change_column :guilds, :owner_id, :string, limit: 36
  end
end
