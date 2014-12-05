# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141201055154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conference_rooms", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", primary_key: "sap_id", force: true do |t|
    t.string   "name"
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees_meetings", id: false, force: true do |t|
    t.integer "meeting_id"
    t.integer "employee_id"
  end

  create_table "employees_teams", id: false, force: true do |t|
    t.integer "team_id"
    t.integer "employee_id"
  end

  create_table "meetings", force: true do |t|
    t.integer  "conference_room_id"
    t.integer  "booked_by"
    t.datetime "start_time",         null: false
    t.datetime "end_time",           null: false
    t.string   "agenda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meetings", ["conference_room_id"], name: "index_meetings_on_conference_room_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
