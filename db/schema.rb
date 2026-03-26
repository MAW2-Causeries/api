# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_17_074008) do
  create_table "guilds", id: :string, charset: "utf8mb3", force: :cascade do |t|
    t.string "banner_picture_path", null: false
    t.datetime "created_at", null: false
    t.string "creator_id", null: false
    t.string "description"
    t.string "name", null: false
    t.string "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "fk_rails_bf778c79cf"
    t.index ["owner_id"], name: "fk_rails_e5adc31fa8"
  end

  create_table "roomTypes", id: :string, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", id: :string, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "guild_id", null: false
    t.string "room_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["guild_id"], name: "fk_rails_028d5e0dc2"
    t.index ["room_type_id"], name: "fk_rails_f4fff90e9d"
  end

  create_table "users", id: :string, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "phone_number"
    t.string "profile_picture_path", default: "default_profile_pic.png", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "guilds", "users", column: "creator_id"
  add_foreign_key "guilds", "users", column: "owner_id"
  add_foreign_key "rooms", "guilds"
  add_foreign_key "rooms", "roomTypes", column: "room_type_id"
end
