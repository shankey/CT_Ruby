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

ActiveRecord::Schema.define(version: 20161129122539) do

  create_table "collections", force: :cascade do |t|
    t.integer  "resource_id",     limit: 4
    t.string   "collection_type", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "collection_id",   limit: 4
  end

  create_table "story_pictures", force: :cascade do |t|
    t.integer  "travel_story_id",      limit: 4
    t.string   "url",                  limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.string   "caption",              limit: 255
  end

  create_table "travel_stories", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "completed",          limit: 4
    t.string   "image",              limit: 255
    t.string   "title",              limit: 255
    t.string   "location",           limit: 255
    t.integer  "live",               limit: 4
    t.string   "canonical_location", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "external_id",       limit: 255
    t.string   "access_token",      limit: 255
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "remember_digest",   limit: 255
    t.string   "password_digest",   limit: 255
    t.string   "profile_pictures",  limit: 255
    t.string   "blog_title",        limit: 255
    t.string   "blog_cover_image",  limit: 255
    t.string   "user_tile_picture", limit: 255
  end

end
