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

ActiveRecord::Schema.define(:version => 20120911061348) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.text     "database"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
    t.string   "url"
    t.text     "settings"
    t.text     "api"
  end

  create_table "auth_sys", :force => true do |t|
    t.integer  "user_id"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  add_index "auth_sys", ["user_id"], :name => "index_auth_sys_on_user_id"

  create_table "batch_records", :force => true do |t|
    t.integer  "profile_id"
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batch_records", ["created_at"], :name => "index_batch_records_on_created_at"
  add_index "batch_records", ["login"], :name => "index_batch_records_on_login"
  add_index "batch_records", ["profile_id"], :name => "index_batch_records_on_profile_id"

  create_table "customized_idp_table_columns", :force => true do |t|
    t.integer  "profile_id"
    t.string   "app_name"
    t.string   "idp_table_name"
    t.string   "column_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customized_idp_table_columns", ["profile_id", "app_name", "idp_table_name"], :name => "table_name_index"

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eco_apps_stores", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "api"
    t.text     "database"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eco_apps_stores", ["name"], :name => "index_eco_apps_stores_on_name"

  create_table "fast_sessions", :id => false, :force => true do |t|
    t.integer   "session_id_crc",               :null => false
    t.string    "session_id",     :limit => 32, :null => false
    t.timestamp "updated_at",                   :null => false
    t.text      "data"
  end

  add_index "fast_sessions", ["session_id_crc", "session_id"], :name => "session_id", :unique => true
  add_index "fast_sessions", ["updated_at"], :name => "updated_at"

  create_table "home_pages", :force => true do |t|
    t.integer  "width"
    t.integer  "height"
    t.integer  "navbar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "host_settings", :force => true do |t|
    t.integer "host_id"
    t.integer "domain_id"
    t.integer "setting_id"
    t.string  "host_type"
    t.string  "setting_type"
    t.integer "position"
  end

  add_index "host_settings", ["host_type", "host_id", "domain_id", "setting_type", "position"], :name => "index_on_type_and_setting"

  create_table "id_gens", :force => true do |t|
    t.integer "value"
  end

  create_table "interaction_controls", :force => true do |t|
    t.integer  "profile_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interaction_controls", ["end_at"], :name => "index_interaction_controls_on_end_at"
  add_index "interaction_controls", ["profile_id"], :name => "index_interaction_controls_on_profile_id"
  add_index "interaction_controls", ["start_at"], :name => "index_interaction_controls_on_start_at"

  create_table "layouts", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link_group_links", :force => true do |t|
    t.integer  "link_id"
    t.integer  "link_group_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "link_group_links", ["link_group_id", "position"], :name => "index_link_group_links_on_link_group_id_and_position"

  create_table "link_groups", :force => true do |t|
    t.integer  "role_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_en"
    t.string   "name_zh"
  end

  create_table "links", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_en"
    t.string   "name_zh"
    t.string   "app"
    t.text     "description"
    t.string   "info_page"
    t.text     "description_en"
    t.text     "description_zh"
    t.string   "target_page"
    t.string   "type"
  end

  create_table "navbars", :force => true do |t|
    t.string  "label"
    t.string  "action"
    t.integer "right_id"
  end

  create_table "partner_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "permit_times"
    t.string   "partner_uid"
    t.string   "partner_name"
    t.string   "lesson_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_roles", :force => true do |t|
    t.integer "role_id"
    t.integer "profile_id"
  end

  add_index "profile_roles", ["profile_id", "role_id"], :name => "index_profile_roles_on_profile_id_and_role_id", :unique => true

  create_table "profiles", :force => true do |t|
    t.string   "login"
    t.string   "mail"
    t.string   "given_name"
    t.string   "surname"
    t.string   "display_name"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "time_zone"
    t.string   "locale"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal_address"
    t.string   "postal_city"
    t.string   "postal_state"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "mobile"
    t.string   "msn"
    t.string   "qq"
    t.string   "skype"
    t.integer  "gender"
    t.string   "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gtalk"
    t.string   "connect_number"
    t.integer  "region_id"
    t.string   "connect_type"
    t.string   "channel"
    t.string   "from_page"
    t.string   "wizard_status"
    t.string   "user_type"
    t.boolean  "all_day_interaction", :default => false
    t.string   "avatar_url"
    t.string   "phone2"
    t.string   "remote_ip"
    t.boolean  "msn_public",          :default => false
    t.boolean  "qq_public",           :default => false
    t.boolean  "skype_public",        :default => false
    t.boolean  "gtalk_public",        :default => false
    t.string   "from_partner"
    t.string   "queue_css"
    t.integer  "flow_type",           :default => 0
    t.string   "uuid"
    t.datetime "last_seen_at"
    t.string   "remember_token"
    t.string   "mail_token"
    t.string   "client_type"
    t.string   "thinkingcap_student"
  end

  add_index "profiles", ["channel"], :name => "index_profiles_on_channel"
  add_index "profiles", ["from_page"], :name => "index_profiles_on_from_page"
  add_index "profiles", ["login"], :name => "index_profiles_on_login", :unique => true
  add_index "profiles", ["mail"], :name => "index_profiles_on_mail", :unique => true
  add_index "profiles", ["user_type"], :name => "index_profiles_on_user_type"
  add_index "profiles", ["uuid"], :name => "index_profiles_on_uuid", :unique => true

  create_table "renren_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "renren_uid"
    t.string   "name"
    t.string   "city"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  add_index "renren_profiles", ["renren_uid"], :name => "index_renren_profiles_on_renren_uid"
  add_index "renren_profiles", ["user_id"], :name => "index_renren_profiles_on_user_id"

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "right_type"
  end

  add_index "rights", ["parent_id"], :name => "index_rights_on_parent_id"

  create_table "role_portal_links", :force => true do |t|
    t.integer "role_id"
    t.integer "portal_link_id"
  end

  add_index "role_portal_links", ["role_id", "portal_link_id"], :name => "index_role_portal_links_on_role_id_and_portal_link_id"

  create_table "role_profiles", :force => true do |t|
    t.integer "role_id"
    t.integer "profile_id"
  end

  add_index "role_profiles", ["role_id", "profile_id"], :name => "index_role_profiles_on_role_id_and_profile_id", :unique => true

  create_table "role_rights", :force => true do |t|
    t.integer "role_id"
    t.integer "right_id"
    t.string  "path"
  end

  add_index "role_rights", ["path"], :name => "index_role_rights_on_path"
  add_index "role_rights", ["right_id"], :name => "index_role_rights_on_right_id"
  add_index "role_rights", ["role_id"], :name => "index_role_rights_on_role_id"

  create_table "role_settings", :force => true do |t|
    t.integer "role_id"
    t.integer "content_id"
    t.string  "content_type"
  end

  add_index "role_settings", ["role_id"], :name => "index_role_settings_on_role_id"

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "position"
    t.string  "name_en"
    t.string  "name_zh"
    t.boolean "has_children", :default => false
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id",                       :null => false
    t.text     "data",       :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "spicus", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "client_id"
    t.string   "name"
    t.string   "skype"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spicus", ["profile_id"], :name => "index_spicus_on_profile_id", :unique => true

  create_table "spicus_students", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "client_id"
    t.string   "name"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spicus_students", ["client_id"], :name => "index_spicus_students_on_client_id", :unique => true
  add_index "spicus_students", ["profile_id"], :name => "index_spicus_students_on_profile_id", :unique => true

  create_table "spicus_trainers", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "client_id"
    t.string   "name"
    t.string   "skype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spicus_trainers", ["client_id"], :name => "index_spicus_trainers_on_client_id", :unique => true
  add_index "spicus_trainers", ["profile_id"], :name => "index_spicus_trainers_on_profile_id", :unique => true

  create_table "styles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_domain_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_domain_roles", ["role_id", "domain_id"], :name => "index_user_domain_roles_on_role_id_and_domain_id"
  add_index "user_domain_roles", ["user_id", "domain_id"], :name => "index_user_domain_roles_on_user_id_and_domain_id"

  create_table "user_links", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_links", ["user_id"], :name => "index_user_links_on_user_id"

  create_table "user_settings", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_settings", ["user_id", "key"], :name => "index_user_settings_on_user_id_and_key"

  create_table "users", :force => true do |t|
    t.integer  "profile_id"
    t.boolean  "customized"
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "remember_token_expires_at"
    t.datetime "last_seen_at"
    t.string   "mail_token"
  end

  add_index "users", ["mail_token"], :name => "index_users_on_mail_token"
  add_index "users", ["profile_id"], :name => "index_users_on_profile_id"

end
