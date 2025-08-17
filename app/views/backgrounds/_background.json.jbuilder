# frozen_string_literal: true

json.extract! background, :id, :image, :created_at, :updated_at
json.url background_url(background, format: :json)
json.image url_for(background.image)
