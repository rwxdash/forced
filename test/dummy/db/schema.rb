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

ActiveRecord::Schema.define(version: 2018_11_05_210218) do

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forced_app_versions", force: :cascade do |t|
    t.integer "client"
    t.string "version", limit: 255
    t.boolean "force_update", default: false
    t.text "changelog"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forced_clients", force: :cascade do |t|
    t.string "item_type"
    t.integer "item_id"
    t.string "identifier"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_forced_clients_on_identifier", unique: true
    t.index ["item_type", "item_id"], name: "index_forced_clients_on_item_type_and_item_id"
  end

  create_table "forced_versions", force: :cascade do |t|
    t.integer "client_id"
    t.string "version", limit: 255
    t.boolean "force_update", default: false
    t.text "changelog"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_forced_versions_on_client_id"
  end

end
