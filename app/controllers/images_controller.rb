class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @property = current_agent.properties.where(url: params[:property_id]).first
    @image = @property.images.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @property, notice: 'Image was successfully created.' }
        format.json
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to pending_prroperty_path(@property), notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to pending_property_path(@property) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @property = Property.find(params[:property_id])
      @image = @property.images.find(params[:id]) if current_agent == @property.agent
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:title, :property_id, :file_name, :assets_uuid, :position, :main_image, :direct_upload_url, :processed)
    end
end
