class CreateFeeds < ActiveRecord::Migration[6.1]
  def change
    create_table :feeds, id: :uuid do |t|
      t.string :title
      t.text :description
      t.jsonb :image
      t.string :url
      t.string :categories, array: true
      t.float :rank, default: 0
      t.integer :status, default: 0
      t.integer :entries_count, default: 0
      t.string :language
      t.datetime :last_import_at
      t.timestamps
    end

    add_index :feeds, :categories, using: 'gin'
    add_index :feeds, :url, unique: true
    add_index :feeds, :language
  end
end
