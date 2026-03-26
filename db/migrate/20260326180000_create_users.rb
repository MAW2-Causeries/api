class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, primary_key: :id, id: :string, limit: 36 do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :phone_number
      t.string :profile_picture_path, null: false, default: "default_profile_pic.png"
      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
