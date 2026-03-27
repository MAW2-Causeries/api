class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, primary_key: :id, id: :string, limit: 36 do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false, default: ""
      t.string :phone_number
      t.string :jti, null: false, default: ""
      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :jti, unique: true
  end
end
