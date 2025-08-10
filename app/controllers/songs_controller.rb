# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_song, only: [ :show, :edit, :update, :destroy ]

  def index
    @songs = Song.order(created_at: :desc)
  end

  def show
  end

  # GET /songs/new
  def new
  end

  def edit
  end

  def create
    params[:files].map do |file|
      Song.create!(file: file)
    end

    redirect_to songs_path, notice: "Songs were successfully created."
  end

  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: "Song was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @song.destroy!

    respond_to do |format|
      format.html { redirect_to songs_path, notice: "Song was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_song
    @song = Song.find(params.expect(:id))
  end

  def song_params
    params.expect(song: [ :title, :artist, :album, :cover_image ])
  end
end
