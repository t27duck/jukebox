# frozen_string_literal: true

class Song < ApplicationRecord
  has_one_attached :file
  has_one_attached :cover_image

  after_create_commit :determine_metadata

  private

  def determine_metadata
    Dir.mktmpdir do |tmpdir|
      file.open(tmpdir: tmpdir) do |mp3file|
        Mp3Info.open(mp3file.path) do |mp3|
          update(
            title: mp3.tag.title.presence || "Unknown Title",
            artist: mp3.tag.artist.presence || "Unknown Artist",
            album: mp3.tag.album.presence || "Unknown Album"
          )

          if mp3.tag2.pictures.any?
            mp3.tag2.pictures.each do |name, data|
              picturepath = File.join(tmpdir, name)
              File.binwrite(picturepath, data)
              mimetype = Marcel::MimeType.for(File.open(picturepath))

              unless name.ends_with?(".jpg", ".jpeg", ".png")
                name += case mimetype
                when "image/jpeg"
                  ".jpg"
                when "image/png"
                  ".png"
                else
                  ".jpg" # Default to jpg if unknown type
                end
              end

              cover_image.attach(io: File.open(picturepath), filename: name, content_type: mimetype)
            end
          else
            cover_image.attach(io: File.open(Rails.root.join("public", "default_cover_image.png")), filename: "default_cover.jpg", content_type: "image/png")
          end
        end
      end
    end
  end
end
