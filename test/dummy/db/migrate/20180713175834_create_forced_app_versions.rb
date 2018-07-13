# This migration creates the `app_versions` table, the only schema PT requires.
# All other migrations PT provides are optional.
class CreateForcedAppVersions < ActiveRecord::Migration[5.2]

  def change
    create_table :forced_app_versions do |t|
      t.integer :client
      t.string :version, limit: 255
      t.boolean :force_update, nil: false, default: false
      t.text :changelog

      t.timestamps
    end
  end
end