# frozen_string_literal: true

require "test_helper"

class SongsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @song = songs(:one)
  end

  test "should get index" do
    get songs_url
    assert_response :success
  end

  test "should get new" do
    get new_song_url
    assert_response :success
  end

  test "should create songs" do
    assert_difference("Song.count", 2) do
      assert_difference("ActiveStorage::Attachment.count", 4) do
        post songs_url, params: { files: [ fixture_file_upload("song.mp3", "audio/mpeg"), fixture_file_upload("song.mp3", "audio/mpeg") ] }
      end
    end

    assert_redirected_to songs_url
  end

  test "should show song" do
    get song_url(@song)
    assert_response :success
  end

  test "should get edit" do
    get edit_song_url(@song)
    assert_response :success
  end

  test "should update song" do
    patch song_url(@song), params: { song: { album: "different", artist: "different", title: "different" } }
    assert_redirected_to song_url(@song)

    @song.reload
    assert_equal "different", @song.album
    assert_equal "different", @song.artist
    assert_equal "different", @song.title
  end

  test "should destroy song" do
    assert_difference("Song.count", -1) do
      delete song_url(@song)
    end

    assert_redirected_to songs_url
  end
end
