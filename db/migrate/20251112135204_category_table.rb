class CategoryTable < ActiveRecord::Migration[8.1]
  def change
    create_table :roomtypes, id: false do |t|
      t.string :id, primary_key: true
      t.string :name, null: false
      t.string :description, null: true
      t.timestamps
    end
  end
end
