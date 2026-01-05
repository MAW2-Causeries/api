class DeleteSessionTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :sessions
  end
end
