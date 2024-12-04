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

ActiveRecord::Schema[7.2].define(version: 2024_12_02_230539) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "check_ins", force: :cascade do |t|
    t.datetime "check_in_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "child_id", null: false
    t.integer "status", default: 0, null: false
    t.bigint "parent_id", null: false
    t.datetime "check_out_time"
    t.string "first_name"
    t.string "last_name"
    t.string "full_name", null: false
    t.string "parent_email", null: false
    t.index ["child_id", "parent_id"], name: "index_check_ins_on_child_id_and_parent_id"
    t.index ["child_id"], name: "index_check_ins_on_child_id"
    t.index ["parent_id"], name: "index_check_ins_on_parent_id"
  end

  create_table "children", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.string "grade"
    t.text "food_allergies"
    t.text "special_medical_needs"
    t.string "emergency_contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "send_email"
    t.bigint "classroom_id", null: false
    t.string "parent_email"
    t.boolean "checked_in"
    t.datetime "deleted_at"
    t.integer "status"
    t.bigint "parent_id"
    t.index ["age"], name: "index_children_on_age"
    t.index ["classroom_id"], name: "index_children_on_classroom_id"
    t.index ["deleted_at"], name: "index_children_on_deleted_at"
    t.index ["parent_email"], name: "index_children_on_parent_email"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parents", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "sign_in_count"
    t.integer "parent_id"
    t.string "check_out_preference"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_parents_on_deleted_at"
    t.index ["parent_id"], name: "index_parents_on_parent_id"
    t.index ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "confirmed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "check_ins", "children"
  add_foreign_key "check_ins", "parents"
end
