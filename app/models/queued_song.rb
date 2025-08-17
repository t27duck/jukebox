# frozen_string_literal: true

class QueuedSong < ApplicationRecord
  belongs_to :song

  def self.next_for(session_id)
    record = next_or_generate_for(session_id)

    song = record.song
    record.update(played: true)
    song
  end

  private

  def self.next_or_generate_for(session_id)
    where(session_id: session_id, played: false).first || generate_for(session_id)
  end
  private_class_method :next_or_generate_for

  def self.generate_for(session_id)
    where(session_id: session_id, played: true).delete_all
    ActiveRecord::Base.connection.execute(<<-SQL.squish)
      INSERT INTO #{quoted_table_name} (session_id, song_id, created_at, updated_at)
      SELECT #{ActiveRecord::Base.connection.quote(session_id)}, songs.id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM songs
      ORDER BY RANDOM()
    SQL

    next_or_generate_for(session_id)
  end
  private_class_method :generate_for
end
