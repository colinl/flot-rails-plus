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

ActiveRecord::Schema.define(version: 20151014195503) do

  create_table "plot2_values", force: :cascade do |t|
    t.integer  "x2"
    t.float    "v1_2"
    t.float    "v2_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plot_values", force: :cascade do |t|
    t.float    "x"
    t.datetime "timestamp"
    t.float    "v1"
    t.float    "v2"
    t.integer  "v3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
