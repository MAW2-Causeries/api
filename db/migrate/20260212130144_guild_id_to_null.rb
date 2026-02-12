class GuildIdToNull < ActiveRecord::Migration[8.1]
  def change
    change_column :channels, :guild_id, :string, limit: 36, null: true
  end
end
