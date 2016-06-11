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

ActiveRecord::Schema.define(version: 20160608145652) do

  create_table "scenarios", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "description"
    t.string   "name"
    t.integer  "ret_taxrate"
    t.float    "inflation_rate"
    t.boolean  "retirement_inflation"
    t.boolean  "education_inflation"
    t.integer  "retirement_startage"
    t.integer  "retirement_income"
    t.integer  "education_endage"
    t.integer  "education_startage"
    t.integer  "education_expense"
    t.boolean  "other_inflation"
    t.boolean  "pension_inflation"
    t.boolean  "socialsecurity_inflation"
    t.integer  "other_startage"
    t.integer  "other_income"
    t.integer  "pension_startage"
    t.integer  "pension_income"
    t.integer  "socialsecurity_startage"
    t.integer  "socialsecurity_income"
    t.float    "bonds_ret_ret"
    t.float    "intlstocks_ret_ret"
    t.float    "usstocks_ret_ret"
    t.float    "bonds_ret_pre"
    t.float    "intlstocks_ret_pre"
    t.float    "usstocks_ret_pre"
    t.integer  "bonds_alloc_ret"
    t.integer  "intlstocks_alloc_ret"
    t.integer  "usstocks_alloc_ret"
    t.integer  "bonds_alloc_pre"
    t.integer  "intlstocks_alloc_pre"
    t.integer  "usstocks_alloc_pre"
    t.boolean  "taxaccount_inflation"
    t.boolean  "rothira_inflation"
    t.boolean  "tradira_inflation"
    t.boolean  "retplan_inflation"
    t.integer  "taxaccount_savings"
    t.integer  "taxaccount_assets"
    t.integer  "rothira_savings"
    t.integer  "rothira_assets"
    t.integer  "tradira_savings"
    t.integer  "tradira_assets"
    t.integer  "retplan_savings"
    t.integer  "retplan_assets"
    t.integer  "life_expectancy"
    t.integer  "retirement_age"
    t.integer  "current_age"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
