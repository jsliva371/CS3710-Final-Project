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

ActiveRecord::Schema[7.1].define(version: 2024_11_28_234125) do
  create_table "friends", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.integer "friend_profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_profile_id"], name: "index_friends_on_friend_profile_id"
    t.index ["profile_id", "friend_profile_id"], name: "index_friends_on_profile_id_and_friend_profile_id", unique: true
    t.index ["profile_id"], name: "index_friends_on_profile_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.string "name"
    t.string "rank"
    t.string "main"
    t.text "achievements", default: ""
    t.date "join_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_games_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "username"
    t.string "platforms"
    t.text "bio"
    t.integer "user_id", null: false
    t.string "steam_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "wishlist"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.string "lastname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "friends", "profiles"
  add_foreign_key "friends", "profiles", column: "friend_profile_id"
  add_foreign_key "games", "profiles"
  add_foreign_key "profiles", "users"
end
