# frozen_string_literal: true

class PlayerController < ApplicationController
  def index
    @full_page = true
  end

  def next
    @song = QueuedSong.next_for(session.id.to_s)

    render json: {
      title: @song.title,
      artist: @song.artist,
      album: @song.album,
      file: url_for(@song.file),
      cover_image: url_for(@song.cover_image)
    }
  end
end
