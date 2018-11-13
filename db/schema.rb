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

ActiveRecord::Schema.define(version: 2018_11_13_022515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", id: :serial, force: :cascade do |t|
    t.bigint "timeline_id"
    t.datetime "date"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "share", default: true
  end

  create_table "timelines", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.bigint "twitter_uid"
    t.string "twitter_nickname", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "twitter_access_token"
    t.text "twitter_access_token_secret"
  end

end
