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

ActiveRecord::Schema[7.0].define(version: 2023_09_19_180734) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boxes", force: :cascade do |t|
    t.string "name"
    t.date "dateTo"
    t.integer "priceFrom"
    t.integer "priceTo"
    t.string "place"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id"
    t.string "description"
    t.boolean "invitable", default: true
  end

  create_table "boxes_users", id: false, force: :cascade do |t|
    t.bigint "box_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_id"], name: "index_boxes_users_on_box_id"
    t.index ["user_id"], name: "index_boxes_users_on_user_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.bigint "giver_id", null: false
    t.bigint "recipient_id", null: false
    t.bigint "box_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_id"], name: "index_pairs_on_box_id"
    t.index ["giver_id", "recipient_id", "box_id"], name: "index_pairs_on_giver_and_recipient_and_box"
    t.index ["giver_id"], name: "index_pairs_on_giver_id"
    t.index ["recipient_id"], name: "index_pairs_on_recipient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.date "dateOfBirth"
    t.integer "sex", default: 2
    t.string "phone", limit: 12
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishlists", force: :cascade do |t|
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "pairs", "boxes"
  add_foreign_key "pairs", "users", column: "giver_id"
  add_foreign_key "pairs", "users", column: "recipient_id"
  add_foreign_key "wishlists", "users"
end
