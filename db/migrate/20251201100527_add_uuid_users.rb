class AddUuidUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :uuid, :string, limit: 36
    add_index :users, :uuid, unique: true
  end
end
