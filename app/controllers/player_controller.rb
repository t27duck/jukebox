# frozen_string_literal: true

class PlayerController < ApplicationController
  def index
    # @song = Song.order("RANDOM()").first
  end

  def next
    @song = Song.order("RANDOM()").first

    render json: {
      title: @song.title,
      artist: @song.artist,
      album: @song.album,
      file: url_for(@song.file),
      cover_image: url_for(@song.cover_image)
    }
  end
end
