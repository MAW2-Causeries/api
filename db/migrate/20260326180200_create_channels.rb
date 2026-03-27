class CreateChannels < ActiveRecord::Migration[8.1]
  def change
    create_table :channels, primary_key: :id, id: :string, limit: 36 do |t|
      t.string :name, null: false
      t.string :guild_id, limit: 36
      t.string :type, null: false
      t.string :description
      t.timestamps
    end

    add_index :channels, :guild_id

    add_foreign_key :channels, :guilds, column: :guild_id, primary_key: :id

    create_join_table :channels, :users, column_options: { type: :string, limit: 36 } do |t|
      t.index :channel_id
      t.index :user_id
      t.foreign_key :channels, column: :channel_id, primary_key: :id
      t.foreign_key :users, column: :user_id, primary_key: :id
    end
  end
end
