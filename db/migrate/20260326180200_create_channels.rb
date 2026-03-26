class CreateChannels < ActiveRecord::Migration[8.1]
  def change
    create_table :channels, primary_key: :id, id: :string, limit: 36 do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :guild_id, limit: 36
      t.string :description
      t.timestamps
    end

    add_index :channels, :guild_id
    add_index :channels, [ :guild_id, :name, :category ], unique: true, name: :channels_unique

    add_foreign_key :channels, :guilds, column: :guild_id, primary_key: :id
  end
end
