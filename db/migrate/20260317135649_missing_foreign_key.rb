class MissingForeignKey < ActiveRecord::Migration[8.1]
  def change
    unless foreign_key_exists?(:channels, :guilds, column: :guild_id, primary_key: :uuid)
      add_foreign_key :channels, :guilds, column: :guild_id, primary_key: :uuid
    end
  end
end
