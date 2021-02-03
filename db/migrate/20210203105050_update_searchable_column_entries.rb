class UpdateSearchableColumnEntries < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_column :entries, :searchable

    execute <<-SQL
      ALTER TABLE entries
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('simple', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(body,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(url,'')), 'C')
      ) STORED;
    SQL

    add_index :entries, :searchable, using: :gin, algorithm: :concurrently
  end
end
