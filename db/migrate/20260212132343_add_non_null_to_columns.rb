class AddNonNullToColumns < ActiveRecord::Migration[8.1]
  def change
    change_column_null :channels, :name, false 
    change_column_null :channels, :category, false
    remove_foreign_key :channels, :guilds, column: :guild_id
    change_column_null :channels, :guild_id, true
    add_foreign_key :channels, :guilds, column: :guild_id, primary_key: :uuid

  end
end
