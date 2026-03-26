class CreateGuilds < ActiveRecord::Migration[8.1]
  def change
    create_table :guilds, primary_key: :id, id: :string, limit: 36 do |t|
      t.string :name, null: false
      t.string :description
      t.string :owner_id, null: false, limit: 36
      t.string :creator_id, null: false, limit: 36
      t.string :banner_picture_path, null: false
      t.timestamps
    end

    add_index :guilds, :name, unique: true
    add_index :guilds, :owner_id
    add_index :guilds, :creator_id

    add_foreign_key :guilds, :users, column: :owner_id, primary_key: :id
    add_foreign_key :guilds, :users, column: :creator_id, primary_key: :id
  end
end
