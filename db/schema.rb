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

ActiveRecord::Schema.define(:version => 20140221023510) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "admin_settings", :force => true do |t|
    t.integer  "guidance_time_s1_extension_telecommunication", :default => 7
    t.integer  "guidance_time_s1_telecommunication",           :default => 7
    t.integer  "guidance_time_d3_telecommunication",           :default => 7
    t.integer  "guidance_time_s1_computer_system",             :default => 7
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  create_table "advisors_schedules", :force => true do |t|
    t.integer  "user_id"
    t.string   "monday",     :default => "-"
    t.string   "tuesday",    :default => "-"
    t.string   "wednesday",  :default => "-"
    t.string   "thursday",   :default => "-"
    t.string   "friday",     :default => "-"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "advisors_statuses", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "max_coordinator", :default => 5, :null => false
    t.integer  "coordinator",     :default => 0, :null => false
    t.string   "skills"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "quota_examiner"
    t.string   "code_advisor"
  end

  create_table "attachments", :force => true do |t|
    t.integer  "attachmentable_id"
    t.string   "attachmentable_type"
    t.string   "file"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "documents", :force => true do |t|
    t.integer  "admin_user_id"
    t.string   "name"
    t.string   "file"
    t.string   "document_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "examiners", :force => true do |t|
    t.datetime "datetime"
    t.string   "location"
    t.text     "note"
    t.integer  "final_project_id"
    t.integer  "examiner_1_id"
    t.integer  "examiner_2_id"
    t.integer  "examiner_3_id"
    t.boolean  "accepted"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "finished"
    t.boolean  "revision"
    t.date     "revision_date"
    t.boolean  "can_session",      :default => false
  end

  create_table "faculties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "final_projects", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.integer  "advisor_1_id"
    t.integer  "advisor_2_id"
    t.string   "advisor_2_name"
    t.string   "title"
    t.text     "description"
    t.integer  "progress",                        :default => 0,     :null => false
    t.boolean  "finished",                        :default => false, :null => false
    t.string   "field"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "slug"
    t.string   "document_final_project"
    t.string   "document_revision_final_project"
    t.string   "group_token"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "news", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "notifiable_type"
    t.integer  "notifiable_id"
    t.string   "message"
    t.boolean  "read",            :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "proposals", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.integer  "advisor_1_id"
    t.integer  "advisor_2_id"
    t.string   "advisor_2_name"
    t.string   "title"
    t.text     "description"
    t.integer  "progress",       :default => 0,     :null => false
    t.boolean  "finished",       :default => false, :null => false
    t.string   "exam"
    t.string   "events"
    t.string   "proposal"
    t.string   "decree"
    t.string   "field"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "slug"
    t.string   "group_token"
  end

  create_table "report_final_projects", :force => true do |t|
    t.integer  "final_project_id"
    t.text     "note"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
  end

  create_table "students_statuses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status",     :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "todo_final_projects", :force => true do |t|
    t.integer  "final_project_id",                    :null => false
    t.integer  "user_id",                             :null => false
    t.integer  "issue_number"
    t.string   "title"
    t.text     "message"
    t.boolean  "status",           :default => false, :null => false
    t.string   "slug",                                :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "todo_proposals", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.integer  "issue_number"
    t.string   "title"
    t.text     "message"
    t.boolean  "status",       :default => false, :null => false
    t.string   "slug"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "topic_tags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "advisor_id"
    t.integer  "topic_id"
    t.string   "title_recommended"
    t.text     "description_recommended"
    t.boolean  "status"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "status",          :default => true, :null => false
    t.integer  "proposals_count", :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "slug"
  end

  add_index "topics", ["slug"], :name => "index_topics_on_slug", :unique => true

  create_table "user_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "avatar"
    t.integer  "user_role_id",                         :default => 1,  :null => false
    t.string   "keyid",                  :limit => 10, :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "slug"
    t.text     "address"
    t.string   "phone"
    t.integer  "faculty_id"
  end

  add_index "users", ["keyid"], :name => "index_users_on_keyid", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end
