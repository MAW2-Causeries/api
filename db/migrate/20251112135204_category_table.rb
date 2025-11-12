class CategoryTable < ActiveRecord::Migration[8.1]
  def change
      create_table :roomTypes do |t|
        t.string :name, null: false
        t.string :description, null: true
        t.timestamps
    end
  end
end
