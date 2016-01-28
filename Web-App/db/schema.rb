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

ActiveRecord::Schema.define(version: 20151211145009) do

  create_table "app_builds", force: true do |t|
    t.integer  "level",      null: false
    t.string   "binary_url", null: false
    t.string   "version",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_events", force: true do |t|
    t.integer  "user_id",          null: false
    t.integer  "previous_plan_id", null: false
    t.integer  "new_plan_id",      null: false
    t.integer  "billing_source",   null: false
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name",                                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_token"
    t.string   "whitelabel_icon_url"
    t.string   "whitelabel_text"
    t.string   "header_image_url"
    t.string   "footer_image_url"
    t.string   "watermark_image_url"
    t.string   "company_logo_url"
    t.integer  "default_plan_id"
    t.date     "contract_start_date"
    t.date     "contract_end_date"
    t.boolean  "allow_uploads",           default: true,  null: false
    t.boolean  "simplified_workflow",     default: false, null: false
    t.boolean  "request_user_email",      default: false, null: false
    t.boolean  "videos_require_approval", default: false, null: false
  end

  create_table "company_templates", force: true do |t|
    t.integer  "template_id", null: false
    t.integer  "company_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_templates", ["template_id", "company_id"], name: "index_company_templates_on_template_id_and_company_id", using: :btree

  create_table "company_users", force: true do |t|
    t.integer  "user_id",                 null: false
    t.integer  "company_id",              null: false
    t.integer  "permissions", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_users", ["user_id", "company_id"], name: "index_company_users_on_user_id_and_company_id", unique: true, using: :btree

  create_table "media_items", force: true do |t|
    t.string   "name",       null: false
    t.string   "media_url",  null: false
    t.integer  "company_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "now_users", force: true do |t|
    t.string  "email",                       null: false
    t.string  "account_type",                null: false
    t.integer "user_pkg",        default: 0, null: false
    t.integer "company_id",      default: 0, null: false
    t.string  "license",                     null: false
    t.string  "token",                       null: false
    t.date    "tokenExpiration",             null: false
    t.date    "expiration",                  null: false
    t.string  "purchase_id",                 null: false
  end

  add_index "now_users", ["email", "purchase_id", "license", "token"], name: "index_now_users_on_email_and_purchase_id_and_license_and_token", unique: true, using: :btree

  create_table "now_users_apis", force: true do |t|
    t.string "name",  null: false
    t.string "token", null: false
  end

  add_index "now_users_apis", ["name", "token"], name: "index_now_users_apis_on_name_and_token", unique: true, using: :btree

  create_table "palette_images", force: true do |t|
    t.integer  "recording_id"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.string   "name",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_plan",              default: false, null: false
    t.integer  "max_video_length_seconds",  default: 0,     null: false
    t.integer  "total_video_space_minutes", default: 0,     null: false
    t.integer  "video_filters",             default: 0,     null: false
    t.boolean  "can_download",              default: false, null: false
    t.integer  "video_quality",             default: 0,     null: false
    t.boolean  "youtube_share",             default: false, null: false
    t.boolean  "custom_watermark",          default: false, null: false
    t.boolean  "custom_header_graphic",     default: false, null: false
    t.boolean  "custom_footer_graphic",     default: false, null: false
    t.boolean  "video_analytics",           default: false, null: false
  end

  create_table "recording_images", force: true do |t|
    t.text     "associated_string",                          null: false
    t.string   "image_url",                                  null: false
    t.decimal  "start_time",        precision: 10, scale: 3, null: false
    t.decimal  "end_time",          precision: 10, scale: 3, null: false
    t.integer  "scroll_height",                              null: false
    t.integer  "scroll_y_value",                             null: false
    t.integer  "recording_id",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parse_id"
  end

  create_table "recordings", force: true do |t|
    t.integer  "template_id"
    t.integer  "created_by",                                                          null: false
    t.integer  "presentation_template_id"
    t.string   "title",                                             default: "",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "font_size",                                         default: 40,      null: false
    t.decimal  "expected_length",          precision: 10, scale: 3,                   null: false
    t.text     "script"
    t.integer  "scroll_speed",                                      default: 55
    t.string   "video_url"
    t.integer  "status",                                            default: 0,       null: false
    t.string   "thumbnail_url"
    t.decimal  "duration",                 precision: 10, scale: 3, default: 0.0,     null: false
    t.string   "video_background_color",                            default: "0/0/0"
    t.string   "parse_id"
    t.string   "parse_video_uuid"
    t.string   "youtube_url"
    t.string   "transcoded_video_url"
    t.string   "transcoder_job_id"
    t.string   "transcoder_error_message"
    t.text     "palette_images"
    t.datetime "deleted_at"
    t.boolean  "sharing_approved",                                  default: true,    null: false
  end

  add_index "recordings", ["created_by"], name: "index_recordings_on_created_by", using: :btree

  create_table "sharing_outputs", force: true do |t|
    t.integer  "company_id",  null: false
    t.string   "oauth_token", null: false
    t.integer  "output_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sharing_outputs", ["company_id"], name: "index_sharing_outputs_on_company_id", using: :btree

  create_table "templates", force: true do |t|
    t.integer  "created_by",               null: false
    t.integer  "presentation_template_id"
    t.string   "title",                    null: false
    t.string   "tag_url",                  null: false
    t.string   "watermark_url",            null: false
    t.string   "left_sidebar_url"
    t.string   "right_sidebar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "templates", ["created_by"], name: "index_templates_on_created_by", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "plan_id",                                null: false
    t.boolean  "is_admin",               default: false, null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "status",                 default: 0,     null: false
    t.date     "plan_expiration"
    t.string   "parse_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "view_records", force: true do |t|
    t.integer  "recording_id",             null: false
    t.date     "view_date",                null: false
    t.integer  "view_count",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
