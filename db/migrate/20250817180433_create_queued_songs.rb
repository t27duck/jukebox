class CreateQueuedSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :queued_songs do |t|
      t.string :session_id, null: false
      t.references :song, null: false, foreign_key: true
      t.boolean :played, null: false, default: false

      t.timestamps
    end
  end
end
