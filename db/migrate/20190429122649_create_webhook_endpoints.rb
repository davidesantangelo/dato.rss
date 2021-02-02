class CreateWebhookEndpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :webhook_endpoints, id: :uuid do |t|
      t.string :url, null: false
      t.string :events, null: false, array: true
      t.references :feed, index: true, foreign_key: true, type: :uuid, null: false
      t.references :token, index: true, foreign_key: true, type: :uuid, null: false
      t.timestamps
    end

    add_index :webhook_endpoints, :url
    add_index :webhook_endpoints, :events, using: 'gin'
    add_index :webhook_endpoints, %i[feed_id token_id]
    add_index :webhook_endpoints, %i[feed_id token_id url], unique: true
  end
end
