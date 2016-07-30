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

ActiveRecord::Schema.define(version: 20160809132509) do

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

  create_table "rooms", force: :cascade do |t|
    t.string   "name",       limit: 50,                 null: false
    t.boolean  "active",                default: false
    t.float    "weight",                default: 1.0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["name"], name: "index_rooms_on_name", using: :btree
  end

  create_table "sensor_types", force: :cascade do |t|
    t.string   "model",        limit: 50, null: false
    t.string   "manufacturer", limit: 50, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
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
    t.index ["manufacturer_id"], name: "index_sensors_on_manufacturer_id", using: :btree
    t.index ["room_id"], name: "index_sensors_on_room_id", using: :btree
    t.index ["sensor_type_id"], name: "index_sensors_on_sensor_type_id", using: :btree
  end

  add_foreign_key "measurements", "measurement_types", name: "fk_rails_measurements_to_measurement_types", on_delete: :restrict
  add_foreign_key "measurements", "sensors", name: "fk_rails_measurements_to_sensors", on_delete: :cascade
  add_foreign_key "sensors", "rooms", name: "fk_rails_sensors_to_rooms", on_delete: :restrict
  add_foreign_key "sensors", "sensor_types", name: "fk_rails_sensors_to_sensor_types", on_delete: :restrict
end
