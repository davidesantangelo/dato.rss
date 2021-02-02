# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_429_122_649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'
  enable_extension 'uuid-ossp'

  create_table 'entries', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'feed_id'
    t.string 'title'
    t.text 'body'
    t.string 'url'
    t.string 'external_id'
    t.string 'categories', array: true
    t.jsonb 'annotations'
    t.jsonb 'sentiment'
    t.datetime 'published_at'
    t.datetime 'enriched_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['annotations'], name: 'index_entries_on_annotations', using: :gin
    t.index ['categories'], name: 'index_entries_on_categories', using: :gin
    t.index ['external_id'], name: 'index_entries_on_external_id'
    t.index %w[feed_id url], name: 'index_entries_on_feed_id_and_url', unique: true
    t.index ['feed_id'], name: 'index_entries_on_feed_id'
    t.index ['sentiment'], name: 'index_entries_on_sentiment', using: :gin
    t.index ['url'], name: 'index_entries_on_url', unique: true
  end

  create_table 'feeds', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.jsonb 'image'
    t.string 'url'
    t.string 'categories', array: true
    t.float 'rank', default: 0.0
    t.integer 'status', default: 0
    t.integer 'entries_count', default: 0
    t.string 'language'
    t.datetime 'last_import_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['categories'], name: 'index_feeds_on_categories', using: :gin
    t.index ['language'], name: 'index_feeds_on_language'
    t.index ['url'], name: 'index_feeds_on_url', unique: true
  end

  create_table 'logs', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'feed_id'
    t.datetime 'start_import_at'
    t.datetime 'end_import_at'
    t.integer 'entries_count'
    t.jsonb 'metadata'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['feed_id'], name: 'index_logs_on_feed_id'
    t.index ['metadata'], name: 'index_logs_on_metadata', using: :gin
  end

  create_table 'tokens', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'key'
    t.datetime 'expires_at'
    t.boolean 'active', default: true
    t.string 'permissions', default: [], array: true
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['key'], name: 'index_tokens_on_key', unique: true
  end

  create_table 'webhook_endpoints', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'url', null: false
    t.string 'events', null: false, array: true
    t.uuid 'feed_id', null: false
    t.uuid 'token_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['events'], name: 'index_webhook_endpoints_on_events', using: :gin
    t.index %w[feed_id token_id url], name: 'index_webhook_endpoints_on_feed_id_and_token_id_and_url', unique: true
    t.index %w[feed_id token_id], name: 'index_webhook_endpoints_on_feed_id_and_token_id'
    t.index ['feed_id'], name: 'index_webhook_endpoints_on_feed_id'
    t.index ['token_id'], name: 'index_webhook_endpoints_on_token_id'
    t.index ['url'], name: 'index_webhook_endpoints_on_url'
  end

  add_foreign_key 'entries', 'feeds'
  add_foreign_key 'logs', 'feeds'
  add_foreign_key 'webhook_endpoints', 'feeds'
  add_foreign_key 'webhook_endpoints', 'tokens'
end
