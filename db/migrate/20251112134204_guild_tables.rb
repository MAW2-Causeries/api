class GuildTables < ActiveRecord::Migration[8.1]
  def change
    create_table :guilds, primary_key: :uuid, id: :string, limit: 36 do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.string :owner_id, null: false
      t.string :banner_picture_path, null: false # add something for default banner picture
      t.string :creator_id, null: false
      t.timestamps
    end

    add_foreign_key :guilds, :users, column: :owner_id, primary_key: :uuid
    add_foreign_key :guilds, :users, column: :creator_id, primary_key: :uuid
  end
end
