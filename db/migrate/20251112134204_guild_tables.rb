class GuildTables < ActiveRecord::Migration[8.1]
  def change
      create_table :guilds do |t|
        t.string :name, null: false
        t.string :description, null: true
        t.belongs_to :owner, null: false, foreign_key: { to_table: :users }
        t.string :banner_picture_path, null: false # add something for default banner picture
        t.belongs_to :creator, null: false, foreign_key: { to_table: :users }
        t.timestamps
    end
  end
end
