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

ActiveRecord::Schema.define(:version => 20110428200710) do

  create_table "messages", :id => false, :force => true do |t|
    t.string   "id",         :limit => nil, :null => false
    t.string   "user_id",    :limit => nil
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "node",       :limit => 2
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "shards", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.integer  "number"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :id => false, :force => true do |t|
    t.string   "id",         :limit => nil, :null => false
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "node",       :limit => 2
  end

end
