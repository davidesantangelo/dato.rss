class AddSearchableColumnToEntries < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TABLE entries
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('simple', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(body,'')), 'B')
      ) STORED;
    SQL
  end

  def down
    remove_column :entries, :searchable
  end
end
