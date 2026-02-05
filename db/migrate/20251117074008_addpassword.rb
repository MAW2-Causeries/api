class Addpassword < ActiveRecord::Migration[8.1]
  def change
      change_table :users do |t|
        t.string :password_digest, null: false
      end
      change_column_default :users, :profile_picture_path, "default_profile_pic.png"
  end
end
