class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens, id: :uuid do |t|
      t.string :key
      t.datetime :expires_at
      t.boolean :active, default: true
      t.string :permissions, array: true, default: []
      t.timestamps
    end

    add_index :tokens, :key, unique: true
  end
end
