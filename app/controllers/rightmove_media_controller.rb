class RightmoveMediaController < ApplicationController
  before_action :set_rightmove_medium, only: [:show, :edit, :update, :destroy]

  # GET /rightmove_media
  # GET /rightmove_media.json
  def index
    @rightmove_media = RightmoveMedium.all
  end

  # GET /rightmove_media/1
  # GET /rightmove_media/1.json
  def show
  end

  # GET /rightmove_media/new
  def new
    @rightmove_medium = RightmoveMedium.new
  end

  # GET /rightmove_media/1/edit
  def edit
  end

  # POST /rightmove_media
  # POST /rightmove_media.json
  def create
    @rightmove_medium = RightmoveMedium.new(rightmove_medium_params)

    respond_to do |format|
      if @rightmove_medium.save
        format.html { redirect_to @rightmove_medium, notice: 'Rightmove medium was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rightmove_medium }
      else
        format.html { render action: 'new' }
        format.json { render json: @rightmove_medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rightmove_media/1
  # PATCH/PUT /rightmove_media/1.json
  def update
    respond_to do |format|
      if @rightmove_medium.update(rightmove_medium_params)
        format.html { redirect_to @rightmove_medium, notice: 'Rightmove medium was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rightmove_medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rightmove_media/1
  # DELETE /rightmove_media/1.json
  def destroy
    @rightmove_medium.destroy
    respond_to do |format|
      format.html { redirect_to rightmove_media_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rightmove_medium
      @rightmove_medium = RightmoveMedium.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rightmove_medium_params
      params[:rightmove_medium]
    end
end
