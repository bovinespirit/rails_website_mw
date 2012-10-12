# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081212001455) do

  create_table "beam_angles", :force => true do |t|
    t.integer "lantern_id", :null => false
    t.float   "minangle",   :null => false
    t.float   "maxangle",   :null => false
    t.boolean "optional"
  end

  add_index "beam_angles", ["lantern_id", "maxangle", "minangle"], :name => "beam_angles_lantern_id_key", :unique => true

  create_table "comatose_page_versions", :force => true do |t|
    t.integer  "comatose_page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type",      :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                       :default => 0
    t.datetime "updated_on"
    t.datetime "created_on"
    t.string   "menu_title"
  end

  create_table "comatose_pages", :force => true do |t|
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.datetime "updated_on"
    t.datetime "created_on"
    t.string   "menu_title"
    t.integer  "version"
  end

  create_table "contacts", :force => true do |t|
    t.datetime "updated_at"
    t.string   "method_name"
    t.string   "fn"
    t.boolean  "organisation", :default => false
    t.string   "xfn"
    t.string   "href"
  end

  create_table "currents", :force => true do |t|
    t.integer "lantern_id",                  :null => false
    t.integer "voltage",    :default => 230, :null => false
    t.float   "current",                     :null => false
    t.integer "frequency",  :default => 50,  :null => false
  end

  add_index "currents", ["frequency", "lantern_id", "voltage"], :name => "currents_lantern_id_key", :unique => true

  create_table "dmx_channels", :force => true do |t|
    t.integer "lantern_id",                     :null => false
    t.string  "mode",        :default => "DMX", :null => false
    t.integer "channels",    :default => 0,     :null => false
    t.string  "description"
  end

  add_index "dmx_channels", ["lantern_id", "mode"], :name => "dmx_channels_lantern_id_key", :unique => true

  create_table "error_messages", :force => true do |t|
    t.string "error",             :limit => 16, :default => "ERROR",          :null => false
    t.string "name",                            :default => "name",           :null => false
    t.string "short_description",               :default => "No Description", :null => false
    t.text   "long_description"
  end

  create_table "error_messages_lanterns", :id => false, :force => true do |t|
    t.integer "lantern_id",       :null => false
    t.integer "error_message_id", :null => false
  end

  create_table "gobo_sizes", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  add_index "gobo_sizes", ["name"], :name => "gobo_sizes_name_key", :unique => true

  create_table "gobo_wheel_types", :force => true do |t|
    t.string "name", :default => "New Wheel", :null => false
  end

  add_index "gobo_wheel_types", ["name"], :name => "gobo_wheels_name_key", :unique => true

  create_table "gobo_wheel_types_lanterns", :id => false, :force => true do |t|
    t.integer "lantern_id",                        :null => false
    t.integer "gobo_wheel_type_id",                :null => false
    t.integer "quantity",           :default => 1, :null => false
  end

  create_table "gobo_wheels", :force => true do |t|
    t.integer "gobo_wheel_type_id",                :null => false
    t.integer "quantity",           :default => 1, :null => false
    t.integer "gobo_size_id",                      :null => false
    t.text    "comment"
  end

  create_table "gobo_wheels_gobos", :force => true do |t|
    t.integer "gobo_id",       :null => false
    t.integer "gobo_wheel_id", :null => false
    t.integer "position",      :null => false
  end

  add_index "gobo_wheels_gobos", ["gobo_wheel_id", "position"], :name => "gobos_gobo_wheels_gobo_wheel_position_ukey", :unique => true

  create_table "gobo_wheels_lanterns", :id => false, :force => true do |t|
    t.integer "gobo_wheel_id", :null => false
    t.integer "lantern_id",    :null => false
  end

  create_table "gobos", :force => true do |t|
    t.string  "number",          :limit => 10
    t.string  "description",                   :default => "- none -", :null => false
    t.integer "manufacturer_id"
  end

  create_table "lamps", :force => true do |t|
    t.string  "name",            :default => "", :null => false
    t.integer "power",           :default => 0,  :null => false
    t.integer "life"
    t.integer "temp"
    t.integer "manufacturer_id"
  end

  create_table "lamps_lanterns", :id => false, :force => true do |t|
    t.integer "lantern_id", :null => false
    t.integer "lamp_id",    :null => false
  end

  create_table "lantern_types", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  add_index "lantern_types", ["name"], :name => "lantern_types_name_key", :unique => true

  create_table "lanterns", :force => true do |t|
    t.string  "name",            :default => "NEW LANTERN", :null => false
    t.float   "weight"
    t.integer "lantern_type_id", :default => 1,             :null => false
    t.integer "manufacturer_id"
  end

  create_table "lanterns_notes", :id => false, :force => true do |t|
    t.integer "lantern_id", :null => false
    t.integer "note_id",    :null => false
  end

  create_table "lastfm_charts", :force => true do |t|
    t.datetime "from"
    t.boolean  "overall"
    t.boolean  "most_recent"
  end

  create_table "lastfm_items", :force => true do |t|
    t.integer "lastfm_chart_id", :null => false
    t.integer "position",        :null => false
    t.string  "name"
  end

  create_table "manufacturers", :force => true do |t|
    t.string "www"
    t.string "name", :null => false
  end

  add_index "manufacturers", ["name"], :name => "manufacturers_name_key", :unique => true

  create_table "notes", :force => true do |t|
    t.string "title", :default => "Title", :null => false
    t.text   "note",                       :null => false
  end

  create_table "photo_data", :force => true do |t|
    t.binary  "data"
    t.integer "photo_id"
  end

  add_index "photo_data", ["photo_id"], :name => "index_photo_data_on_photo_id"

  create_table "photo_sets", :force => true do |t|
    t.integer "page_id",           :default => 0
    t.string  "page_type"
    t.integer "contents_photo_id"
    t.string  "title"
  end

  add_index "photo_sets", ["page_type"], :name => "index_photo_sets_on_page_type"

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "description"
    t.datetime "updated_on"
    t.datetime "created_on"
    t.text     "text"
    t.integer  "thumb_x",             :default => 0
    t.integer  "thumb_y",             :default => 0
    t.integer  "thumb_l",             :default => 0
    t.boolean  "thumb_vertical",      :default => false
    t.integer  "width",               :default => 0
    t.integer  "height",              :default => 0
    t.string   "camera_model",        :default => "No data"
    t.float    "aperture",            :default => 0.0
    t.string   "exposure",            :default => "No data"
    t.float    "focal_length",        :default => 0.0
    t.string   "metering",            :default => "No data"
    t.boolean  "processed_with_gimp", :default => false
    t.boolean  "vague_created_date",  :default => false
  end

  create_table "photos_photo_sets", :force => true do |t|
    t.integer "photo_id"
    t.integer "photo_set_id"
    t.integer "position"
  end

  create_table "post_versions", :force => true do |t|
    t.integer  "post_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "body"
    t.boolean  "staging",    :default => true
  end

  create_table "posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "body"
    t.boolean  "staging",    :default => true
    t.integer  "version"
  end

  create_table "redirections", :force => true do |t|
    t.string  "uri"
    t.integer "targetable_id"
    t.string  "targetable_type"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

end
