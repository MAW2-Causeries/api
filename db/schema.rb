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

ActiveRecord::Schema[8.1].define(version: 2025_11_12_135311) do
  create_table "guilds", charset: "utf8mb3", force: :cascade do |t|
    t.string "banner_picture_path", null: false
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.string "description"
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_guilds_on_creator_id"
    t.index ["owner_id"], name: "index_guilds_on_owner_id"
  end

  create_table "rooms", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.bigint "guild_id", null: false
    t.bigint "type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["guild_id"], name: "index_rooms_on_guild_id"
    t.index ["type_id"], name: "index_rooms_on_type_id"
  end

  create_table "roomtypes", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.string "profile_picture_path", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "guilds", "users", column: "creator_id"
  add_foreign_key "guilds", "users", column: "owner_id"
  add_foreign_key "rooms", "guilds"
  add_foreign_key "rooms", "roomtypes", column: "type_id"
end
