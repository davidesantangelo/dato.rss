class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries, id: :uuid do |t|
      t.references :feed, index: true, foreign_key: true, type: :uuid
      t.string :title
      t.text :body
      t.string :url
      t.string :external_id
      t.string :categories, array: true
      t.jsonb :annotations
      t.jsonb :sentiment
      t.datetime :published_at
      t.datetime :enriched_at
      t.timestamps
    end

    add_index :entries, :categories, using: 'gin'
    add_index :entries, :url, unique: true
    add_index :entries, :external_id
    add_index :entries, :annotations, using: :gin
    add_index :entries, :sentiment, using: :gin
    add_index :entries, %i[feed_id url], unique: true
  end
end
