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

ActiveRecord::Schema.define(version: 20150114034737) do

  create_table "devices", force: true do |t|
    t.string   "mobile_no"
    t.string   "imei_no"
    t.integer  "vehicle_id"
    t.boolean  "is_enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["vehicle_id"], name: "index_devices_on_vehicle_id", using: :btree

  create_table "routes", force: true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routes", ["vehicle_id"], name: "index_routes_on_vehicle_id", using: :btree

  create_table "schools", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "phone_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stops", force: true do |t|
    t.string   "name"
    t.decimal  "latitude",   precision: 10, scale: 7
    t.decimal  "longitude",  precision: 10, scale: 7
    t.string   "timeperiod"
    t.integer  "sequence"
    t.integer  "route_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stops", ["route_id"], name: "index_stops_on_route_id", using: :btree

  create_table "vehicles", force: true do |t|
    t.string   "registration_no"
    t.integer  "capacity"
    t.string   "vehicle_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "vehicles", ["school_id"], name: "index_vehicles_on_school_id", using: :btree

end
