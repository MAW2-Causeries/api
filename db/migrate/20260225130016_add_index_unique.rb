class AddIndexUnique < ActiveRecord::Migration[8.1]
  def change
    add_index :guilds, :name, unique: true

    add_index :channels, [ :guild_id, :name, :category ], unique: true, name: :channels_unique
  end
end
