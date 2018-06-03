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

ActiveRecord::Schema.define(version: 20180517043006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages", force: :cascade do |t|
    t.string   "path"
    t.text     "text"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "task_id"
    t.integer  "status",     default: 0, null: false
  end

  add_index "pages", ["task_id"], name: "index_pages_on_task_id", using: :btree

  create_table "restrictions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
  end

  add_index "restrictions", ["task_id"], name: "index_restrictions_on_task_id", using: :btree
  add_index "restrictions", ["user_id"], name: "index_restrictions_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "status",     default: 0, null: false
    t.integer  "stage",      default: 0, null: false
    t.integer  "part",       default: 0, null: false
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "order"
    t.string   "path"
    t.integer  "build",      default: 0, null: false
    t.string   "commit_id"
  end

  add_index "tasks", ["order"], name: "index_tasks_on_order", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "facebook_id"
    t.text     "facebook_data"
    t.string   "token"
  end

  add_index "users", ["facebook_id"], name: "index_users_on_facebook_id", unique: true, using: :btree

  add_foreign_key "pages", "tasks"
  add_foreign_key "tasks", "users"
end
