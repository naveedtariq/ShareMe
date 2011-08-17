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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110812024631) do

  create_table "access_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",       :limit => 30
    t.string   "key"
    t.string   "token",      :limit => 1024
    t.string   "secret"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_tokens", ["key"], :name => "index_access_tokens_on_key", :unique => true

  create_table "contacts", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.string   "name",               :null => false
    t.string   "email",              :null => false
    t.integer  "associated_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["associated_user_id"], :name => "index_contacts_on_associated_user_id"
  add_index "contacts", ["email"], :name => "index_contacts_on_email"
  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "profiles", :force => true do |t|
    t.string   "company_name"
    t.string   "company_address"
    t.string   "phone"
    t.string   "fax"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                     :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",                      :null => false
    t.boolean  "active",             :default => false, :null => false
    t.string   "name"
    t.string   "phone"
    t.string   "code"
    t.integer  "active_token_id"
    t.string   "f_name"
    t.string   "l_name"
    t.boolean  "is_local",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

end
