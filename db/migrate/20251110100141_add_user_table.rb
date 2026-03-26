class AddUserTable < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: false do |t|
      t.string :id, primary_key: true
      t.string :username, null: false
      t.string :email, null: false
      t.string :phone_number, null: true
      t.string :profile_picture_path, null: false # add something for default profile picture
      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
