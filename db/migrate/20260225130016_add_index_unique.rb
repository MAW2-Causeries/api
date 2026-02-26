class AddIndexUnique < ActiveRecord::Migration[8.1]
  def change
    add_index :guilds, :name, unique: true

    add_index :channels, [ :name, :guild_id, :category, :uuid ], unique: true
  end
end
