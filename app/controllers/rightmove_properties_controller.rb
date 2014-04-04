class RightmovePropertiesController < ApplicationController
  before_action :set_rightmove_property, only: [:show, :edit, :update, :destroy]

  # GET /rightmove_properties
  # GET /rightmove_properties.json
  def index
    @rightmove_properties = RightmoveProperty.all
  end

  # GET /rightmove_properties/1
  # GET /rightmove_properties/1.json
  def show
  end

  # GET /rightmove_properties/new
  def new
    @rightmove_property = RightmoveProperty.new
  end

  # GET /rightmove_properties/1/edit
  def edit
  end

  # POST /rightmove_properties
  # POST /rightmove_properties.json
  def create
    @rightmove_property = RightmoveProperty.new(rightmove_property_params)

    respond_to do |format|
      if @rightmove_property.save
        format.html { redirect_to @rightmove_property, notice: 'Rightmove property was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rightmove_property }
      else
        format.html { render action: 'new' }
        format.json { render json: @rightmove_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rightmove_properties/1
  # PATCH/PUT /rightmove_properties/1.json
  def update
    respond_to do |format|
      if @rightmove_property.update(rightmove_property_params)
        format.html { redirect_to @rightmove_property, notice: 'Rightmove property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rightmove_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rightmove_properties/1
  # DELETE /rightmove_properties/1.json
  def destroy
    @rightmove_property.destroy
    respond_to do |format|
      format.html { redirect_to rightmove_properties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rightmove_property
      @rightmove_property = RightmoveProperty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rightmove_property_params
      params[:rightmove_property]
    end
end
