class PrimaryUuid < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :guilds, :users
    remove_foreign_key :guilds, :users
    execute "ALTER TABLE users DROP PRIMARY KEY, CHANGE id id int(11);"


    remove_column :users, :id
    execute "ALTER TABLE users ADD PRIMARY KEY (uuid);"
  end
end
