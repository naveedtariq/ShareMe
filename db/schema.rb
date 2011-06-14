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

ActiveRecord::Schema.define(:version => 20110612194932) do

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
    t.integer  "user_id"
    t.string   "encrypted_first_name"
    t.string   "encrypted_last_name"
    t.string   "encrypted_company"
    t.string   "encrypted_google_account"
    t.string   "encrypted_google_password"
    t.string   "encrypted_facebook_account"
    t.string   "encrypted_facebook_password"
    t.string   "encrypted_twitter_account"
    t.string   "encrypted_twitter_password"
    t.string   "encrypted_skype_account"
    t.string   "encrypted_skype_password"
    t.string   "encrypted_linkedin_account"
    t.string   "encrypted_linkedin_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "user_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "secret"
    t.string   "nickname"
  end

  add_index "user_tokens", ["user_id"], :name => "index_user_tokens_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_name"
    t.string   "code"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "encrypted_phone"
    t.boolean  "filled",                                :default => false
    t.string   "encrypted_address"
    t.boolean  "first_signin_fb",                       :default => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
