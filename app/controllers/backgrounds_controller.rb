# frozen_string_literal: true

class BackgroundsController < ApplicationController
  before_action :set_background, only: [ :show, :edit, :update, :destroy ]

  # GET /backgrounds or /backgrounds.json
  def index
    @backgrounds = Background.all
  end

  # GET /backgrounds/1 or /backgrounds/1.json
  def show
  end

  # GET /backgrounds/new
  def new
    @background = Background.new
  end

  # GET /backgrounds/1/edit
  def edit
  end

  # POST /backgrounds or /backgrounds.json
  def create
    params[:files].compact_blank!.each do |file|
      Background.create!(image: file)
    end

    redirect_to backgrounds_path, notice: "Backgrounds were successfully created."
  end

  # PATCH/PUT /backgrounds/1 or /backgrounds/1.json
  def update
    respond_to do |format|
      if @background.update(background_params)
        format.html { redirect_to @background, notice: "Background was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @background }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @background.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /backgrounds/1 or /backgrounds/1.json
  def destroy
    @background.destroy!

    respond_to do |format|
      format.html { redirect_to backgrounds_path, notice: "Background was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_background
      @background = Background.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def background_params
      params.expect(background: [ :image ])
    end
end
