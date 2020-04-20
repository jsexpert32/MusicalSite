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

ActiveRecord::Schema.define(version: 20160921182730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artist_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "critique_id",      null: false
    t.integer  "user_id",          null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "critiques", force: :cascade do |t|
    t.integer  "track_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres_tracks", id: false, force: :cascade do |t|
    t.integer "genre_id"
    t.integer "track_id"
  end

  add_index "genres_tracks", ["genre_id", "track_id"], name: "index_genres_tracks_on_genre_id_and_track_id", unique: true, using: :btree
  add_index "genres_tracks", ["genre_id"], name: "index_genres_tracks_on_genre_id", using: :btree
  add_index "genres_tracks", ["track_id"], name: "index_genres_tracks_on_track_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id",             null: false
    t.string   "uid"
    t.string   "avatar_url"
    t.string   "refresh_token"
    t.string   "access_token_secret"
    t.string   "provider",            null: false
    t.string   "access_token",        null: false
    t.datetime "expires_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", using: :btree

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "actor_id"
    t.datetime "read_at"
    t.string   "action"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "track_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
  end

  add_index "ratings", ["track_id"], name: "index_ratings_on_track_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "shortened_urls", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.text     "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortened_urls", ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type", using: :btree
  add_index "shortened_urls", ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
  add_index "shortened_urls", ["url"], name: "index_shortened_urls_on_url", using: :btree

  create_table "soundbites", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "critique_id"
    t.string   "data_url"
    t.integer  "data_id"
    t.integer  "data_start"
    t.integer  "data_end"
    t.integer  "data_plays"
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "subgenres", force: :cascade do |t|
    t.string   "name"
    t.integer  "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subgenres", ["genre_id"], name: "index_subgenres_on_genre_id", using: :btree

  create_table "subgenres_tracks", id: false, force: :cascade do |t|
    t.integer "subgenre_id"
    t.integer "track_id"
  end

  add_index "subgenres_tracks", ["subgenre_id", "track_id"], name: "index_subgenres_tracks_on_subgenre_id_and_track_id", unique: true, using: :btree
  add_index "subgenres_tracks", ["subgenre_id"], name: "index_subgenres_tracks_on_subgenre_id", using: :btree
  add_index "subgenres_tracks", ["track_id"], name: "index_subgenres_tracks_on_track_id", using: :btree

  create_table "track_charted", force: :cascade do |t|
    t.integer  "track_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "week"
    t.integer  "day"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
  end

  add_index "track_charted", ["track_id", "year", "month"], name: "index_track_charted_on_track_id_and_year_and_month", using: :btree
  add_index "track_charted", ["track_id", "year", "week"], name: "index_track_charted_on_track_id_and_year_and_week", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.integer  "user_id",                           null: false
    t.string   "soundcloud_uri"
    t.string   "artwork_url"
    t.string   "permalink"
    t.text     "description"
    t.integer  "duration"
    t.boolean  "sharing",           default: false
    t.boolean  "commentable",       default: true
    t.boolean  "streamable",        default: true
    t.boolean  "downloadable",      default: false
    t.boolean  "has_vocals",        default: false
    t.boolean  "has_samples",       default: false
    t.string   "title"
    t.boolean  "marked",            default: false, null: false
    t.text     "audio_data"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "artist_type_id"
    t.string   "cover"
    t.float    "rating",            default: 0.0
    t.integer  "social_shares",     default: 0
    t.float    "waveform",          default: [],                 array: true
    t.boolean  "has_beat_switch"
    t.integer  "like_count",        default: 0
    t.integer  "indifferent_count", default: 0
    t.integer  "dislike_count",     default: 0
    t.boolean  "contactable",       default: false
    t.boolean  "is_charted",        default: false
    t.text     "image_data"
  end

  add_index "tracks", ["contactable"], name: "index_tracks_on_contactable", using: :btree
  add_index "tracks", ["has_samples"], name: "index_tracks_on_has_samples", using: :btree
  add_index "tracks", ["has_vocals"], name: "index_tracks_on_has_vocals", using: :btree
  add_index "tracks", ["rating"], name: "index_tracks_on_rating", using: :btree
  add_index "tracks", ["user_id"], name: "index_tracks_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "country"
    t.string   "city"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "description"
    t.string   "token"
    t.string   "reset_password_token"
    t.datetime "last_activity_at"
    t.string   "avatar"
    t.boolean  "confirmed",              default: false
    t.string   "password_digest"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.text     "bio"
    t.string   "background_image"
    t.boolean  "is_visible",             default: true
    t.string   "slug"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.jsonb    "roles",                  default: {"admin"=>false, "producer"=>false}
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["roles"], name: "index_users_on_roles", using: :gin
  add_index "users", ["token"], name: "index_users_on_token", using: :btree

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
end
