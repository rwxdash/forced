# This migration creates the `app_clients` and `app_versions` table,
# which `forced` gem requires to run properly.

class CreateForcedTables < ActiveRecord::Migration[5.2]
  def change
    create_table :forced_clients do |t|
      t.references :owner, polymorphic: true, index: true
      t.string :identifier, index: { unique: true }
      t.datetime :deleted_at

      t.timestamps
    end

    create_table :forced_versions do |t|
      t.references :client, foreign_key: { to_table: :forced_clients }
      t.string :version, limit: 255
      t.boolean :force_update, nil: false, default: false
      t.text :changelog
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
