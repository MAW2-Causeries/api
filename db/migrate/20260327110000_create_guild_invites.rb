class CreateGuildInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :guild_invites, primary_key: :id, id: :string, limit: 36 do |t|
      t.string :guild_id, null: false, limit: 36
      t.string :creator_id, null: false, limit: 36
      t.string :token, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :guild_invites, :token, unique: true
    add_index :guild_invites, :guild_id
    add_index :guild_invites, :creator_id

    add_foreign_key :guild_invites, :guilds, column: :guild_id, primary_key: :id
    add_foreign_key :guild_invites, :users, column: :creator_id, primary_key: :id
  end
end
