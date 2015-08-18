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

ActiveRecord::Schema.define(version: 20150817182319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contest_seeds", force: true do |t|
    t.string  "game_identifier",                           null: false
    t.integer "size",                                      null: false
    t.integer "buy_in",                                    null: false
    t.integer "minutes_before_lock_cutoff", default: 60,   null: false
    t.boolean "is_active",                  default: true, null: false
  end

  add_index "contest_seeds", ["game_identifier", "size", "buy_in"], name: "index_contest_seeds_on_game_identifier_and_size_and_buy_in", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                          null: false
    t.string   "crypted_password",               null: false
    t.string   "password_salt",                  null: false
    t.string   "persistence_token",              null: false
    t.string   "perishable_token",               null: false
    t.integer  "login_count",        default: 0, null: false
    t.integer  "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

end
