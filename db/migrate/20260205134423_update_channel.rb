class UpdateChannel < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :rooms, :roomtypes
    remove_column :rooms, :type_id
    add_column :rooms, :category, :string
    add_column :rooms, :name, :string
    remove_foreign_key :rooms, :guilds
    rename_column :rooms, :id, :uuid

    rename_table :rooms, :channels

    drop_table :roomtypes
    remove_column :channels, :uuid
    add_column :channels, :uuid, :string, limit: 36
    execute "ALTER TABLE channels ADD PRIMARY KEY (uuid);"
    remove_column :guilds, :id
    add_column :guilds, :uuid, :string, limit: 36
    execute "ALTER TABLE guilds ADD PRIMARY KEY (uuid);"

    change_column :guilds, :creator_id, :string, limit: 36
    change_column :guilds, :owner_id, :string, limit: 36
    add_foreign_key :guilds, :users, column: :owner_id, primary_key: :uuid
    add_foreign_key :guilds, :users, column: :creator_id, primary_key: :uuid
  end
end
