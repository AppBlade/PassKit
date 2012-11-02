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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121102200719) do

  create_table "instances", :force => true do |t|
    t.datetime "relevant_date"
    t.string   "description"
    t.integer  "pass_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "logo"
    t.string   "logo_2x"
    t.string   "background"
    t.string   "background_2x"
    t.string   "icon"
    t.string   "icon_2x"
    t.string   "background_color"
    t.string   "foreground_color"
    t.string   "label_color"
    t.string   "logo_text"
    t.boolean  "suppress_strip_shine"
    t.string   "barcode_format"
    t.string   "barcode_message_encoding"
  end

  create_table "issuances", :force => true do |t|
    t.integer  "instance_id"
    t.string   "barcode_alt_text"
    t.string   "barcode_message"
    t.string   "email"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "registration_secret"
  end

  create_table "passes", :force => true do |t|
    t.string   "organization_name"
    t.string   "pass_type_identifier"
    t.string   "team_identifier"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "p12_file"
    t.string   "p12_passcode"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "issuance_id"
    t.string   "push_token"
    t.string   "device_library_identifier"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

end
