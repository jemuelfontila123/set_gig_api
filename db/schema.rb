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

ActiveRecord::Schema[7.0].define(version: 2023_09_15_210045) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "role_id", default: ["0"], array: true
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "unique_username", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "previous_events"
    t.bigint "schedule_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contact_information_id"
    t.index ["contact_information_id"], name: "index_bookings_on_contact_information_id"
    t.index ["schedule_id"], name: "index_bookings_on_schedule_id"
  end

  create_table "contact_informations", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_number"
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contact_type", default: 0
    t.string "password_digest"
  end

  create_table "online_links", force: :cascade do |t|
    t.string "link_type"
    t.text "url"
    t.bigint "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_online_links_on_booking_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "availability", default: true
    t.integer "schedule_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locked_token"
    t.datetime "locked_at"
  end

  create_table "tentative_lineups", force: :cascade do |t|
    t.string "band_name"
    t.string "genres", default: [], array: true
    t.bigint "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_tentative_lineups_on_booking_id"
  end

  add_foreign_key "bookings", "contact_informations"
  add_foreign_key "bookings", "schedules"
  add_foreign_key "online_links", "bookings"
  add_foreign_key "tentative_lineups", "bookings"
end
