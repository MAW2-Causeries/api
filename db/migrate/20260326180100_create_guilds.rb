class CreateGuilds < ActiveRecord::Migration[8.1]
  def change
    create_table :guilds, primary_key: :id, id: :string, limit: 36 do |t|
      t.string :name, null: false
      t.string :description
      t.string :owner_id, null: false, limit: 36
      t.string :creator_id, null: false, limit: 36
      t.timestamps
    end

    add_index :guilds, :name
    add_index :guilds, :owner_id
    add_index :guilds, :creator_id

    add_foreign_key :guilds, :users, column: :owner_id, primary_key: :id
    add_foreign_key :guilds, :users, column: :creator_id, primary_key: :id

    create_join_table :guilds, :users, column_options: { type: :string, limit: 36 } do |t|
      t.index [ :guild_id, :user_id ], unique: true
      t.index :user_id
    end
  end
end
