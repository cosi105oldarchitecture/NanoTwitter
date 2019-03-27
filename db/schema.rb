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

ActiveRecord::Schema.define(version: 2019_02_26_212737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
    t.string "follower_handle"
    t.string "followee_handle"
  end

  create_table "hashtags", force: :cascade do |t|
    t.text "name"
  end

  create_table "mentions", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "mentioned_user_id"
  end

  create_table "timeline_pieces", force: :cascade do |t|
    t.integer "timeline_owner_id"
    t.integer "tweet_id"
    t.string "tweet_body"
    t.datetime "tweet_created_on"
    t.string "tweet_author_handle"
  end

  create_table "tweet_tags", force: :cascade do |t|
    t.integer "hashtag_id"
    t.integer "tweet_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.string "body"
    t.datetime "created_on"
    t.integer "author_id"
    t.string "author_handle"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "handle"
    t.string "password_digest"
  end

end
