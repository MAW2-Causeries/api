class ForeignKeyGuildChannels < ActiveRecord::Migration[8.1]
  def change
    change_column :channels, :guild_id, :string, limit: 36
    add_foreign_key :channels, :guilds, column: :guild_id, primary_key: :uuid
  end
end
