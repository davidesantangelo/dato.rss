class AddPublishedAtIndexToEntries < ActiveRecord::Migration[6.1]
  def change
    add_index :entries, :published_at
  end
end
