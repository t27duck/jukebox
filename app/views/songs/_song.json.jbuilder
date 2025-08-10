# frozen_string_literal: true

json.extract! song, :id, :title, :artist, :album
json.file url_for(song.file)
json.cover_image url_for(song.cover_image)
