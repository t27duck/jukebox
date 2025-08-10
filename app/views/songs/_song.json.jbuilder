# frozen_string_literal: true

json.extract! song, :id, :title, :artist, :album, :file, :created_at, :updated_at
json.url song_url(song, format: :json)
json.file url_for(song.file)
json.cover_image url_for(song.cover_image) if song.cover_image.attached?
