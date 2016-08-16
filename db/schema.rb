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

ActiveRecord::Schema.define(version: 20160814230541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "measurement_types", force: :cascade do |t|
    t.string   "name",       limit: 15, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "measurements", force: :cascade do |t|
    t.integer  "sensor_id",           null: false
    t.integer  "measurement_type_id", null: false
    t.float    "data",                null: false
    t.datetime "recorded_date",       null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "program_schedules", force: :cascade do |t|
    t.integer  "program_id",            null: false
    t.float    "cool_temp"
    t.float    "heat_temp"
    t.integer  "days_of_week_bin_aggr", null: false, comment: "This value is a binary representation of the days of week for the schedule.  Sunday=1 -> Saturday=64.  Ex: Monday, Wednesday, Firday = 42, Sunday-Saturday=127"
    t.time     "time_of_day",           null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["program_id"], name: "index_program_schedules_on_program_id", using: :btree
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name",       limit: 50,                 null: false
    t.boolean  "active",                default: false
    t.float    "weight",                default: 1.0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["id"], name: "rooms_id_key", unique: true, using: :btree
    t.index ["name"], name: "index_rooms_on_name", using: :btree
  end

  create_table "sensor_types", force: :cascade do |t|
    t.string   "model",        limit: 50, null: false
    t.string   "manufacturer", limit: 50, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["id"], name: "sensor_types_id_key", unique: true, using: :btree
    t.index ["manufacturer"], name: "index_sensor_types_on_manufacturer", using: :btree
    t.index ["model"], name: "index_sensor_types_on_model", using: :btree
  end

  create_table "sensors", force: :cascade do |t|
    t.string   "name",            limit: 255,                 null: false
    t.string   "manufacturer_id", limit: 255
    t.integer  "sensor_type_id",                              null: false
    t.integer  "room_id"
    t.boolean  "active",                      default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index ["manufacturer_id"], name: "index_sensors_on_manufacturer_id", unique: true, using: :btree
    t.index ["room_id"], name: "index_sensors_on_room_id", using: :btree
    t.index ["sensor_type_id"], name: "index_sensors_on_sensor_type_id", using: :btree
  end

  create_table "system_modes", force: :cascade do |t|
    t.string   "name",                         null: false
    t.boolean  "has_programs", default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["has_programs"], name: "index_system_modes_on_has_programs", using: :btree
    t.index ["name"], name: "index_system_modes_on_name", using: :btree
  end

  create_table "system_settings", force: :cascade do |t|
    t.integer  "current_program_id"
    t.integer  "system_mode_id",     null: false
    t.float    "cool_temp"
    t.float    "heat_temp"
    t.boolean  "active",             null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["active"], name: "index_system_settings_on_active", using: :btree
  end

  add_foreign_key "measurements", "measurement_types", name: "fk_rails_measurements_to_measurement_types", on_delete: :restrict
  add_foreign_key "measurements", "sensors", name: "fk_rails_measurements_to_sensors", on_delete: :cascade
  add_foreign_key "program_schedules", "programs", name: "fk_rails_program_schedules_to_programs", on_delete: :cascade
  add_foreign_key "sensors", "rooms", name: "fk_rails_sensors_to_rooms"
  add_foreign_key "sensors", "sensor_types", name: "fk_rails_sensors_to_sensor_types"
  add_foreign_key "system_settings", "programs", column: "current_program_id", name: "fk_rails_system_settings_to_programs", on_delete: :restrict
  add_foreign_key "system_settings", "system_modes", name: "fk_rails_system_settings_to_system_modes", on_delete: :restrict
end
