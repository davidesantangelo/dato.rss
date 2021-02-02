class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs, id: :uuid do |t|
      t.references :feed, index: true, foreign_key: true, type: :uuid
      t.datetime :start_import_at
      t.datetime :end_import_at
      t.integer :entries_count
      t.jsonb :metadata
      t.timestamps
    end

    add_index :logs, :metadata, using: :gin
  end
end
