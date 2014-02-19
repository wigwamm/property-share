class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy]

  # GET /properties
  # GET /properties.json
  def index
    @properties = current_agent.properties.all
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now.beginning_of_day }).asc(:available_at)
    @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
    if @last_today
      time = Time.parse((@last_today.available_at + 29.minutes).to_s)
      @availability = current_agent.availabilities.new(time: time.round_off(30.minutes).strftime("%H:%M"))
    else
      @availability = current_agent.availabilities.new(time: Time.now.round_off(30.minutes).strftime("%H:%M"))
    end
  end

  # GET /properties/new
  def new
    @property = current_agent.properties.new
    @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now.beginning_of_day }).asc(:available_at)
    @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
    if @last_today
      time = Time.parse((@last_today.available_at + 29.minutes).to_s)
      @availability = current_agent.availabilities.new(time: time.round_off(30.minutes).strftime("%H:%M"))
    else
      @availability = current_agent.availabilities.new(time: Time.now.round_off(30.minutes).strftime("%H:%M"))
    end
    # @images = @property.images.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties
  # POST /properties.json
  def create
    @property = current_agent.properties.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: 'Property was successfully created.' }
        format.json { render action: 'show', status: :created, location: @property }
      else
        format.html { render action: 'new' }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to properties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = current_agent.properties.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:title, :url, :price, :description, :address, :postcode, :view_count, :active )
    end
end
