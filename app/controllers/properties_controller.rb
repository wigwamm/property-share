class PropertiesController < ApplicationController
  before_action :authenticate_agent!, except: [:show]
  before_action :set_property, only: [:show, :edit, :update, :destroy]

  # GET /properties
  # GET /properties.json
  def index
    @properties = current_agent.properties.all
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    @visit = @property.visits.new()
    @visitor = Visitor.new(conversion_property: @property._id)
    if current_agent
      t = current_agent.todays_availabilities
      t.any? ? time = t.last.end_time : time = Time.now
      @availability = current_agent.availabilities.new(start_time: time.round_off(30.minutes).strftime("%H:%M"))
    end
  #   if @property
  #     @agent = @property.agent
  #     @visit = @property.visits.new(agent_id: @agent.id)

  #     if current_agent == @agent

  #       # if @property.tiny_url.blank?
  #       #   shortlink = BITLY.shorten( property_url(@property.agency, @property) )
  #       #   @property.update_attribute("tiny_url", shortlink.short_url )
  #       # end
  #       availabilities = Availability.where( agent_id: current_agent.id).where( :start_time => { :$gte => DateTime.now } ).asc( :start_time )
  #       last_today = availabilities.where( :start_time => { :$lte => DateTime.now.end_of_day } ).asc(:start_time).first
  #       last_today ? time = Time.parse((last_today.start_time + 29.minutes).to_s) : time = Time.now
  #       @images = @property.images.sort_by {|img| img.position }
  #       @grouped_availabilities = availabilities.all.group_by{|v| v.start_time.beginning_of_day }.values if availabilities.any?
  #       @availability = current_agent.availabilities.new(start_time: time.round_off(30.minutes).strftime("%H:%M"))

  #     else

  #       # set tracking cookie if current_agent to see properties other agents are viewing...
  #       # if current_agent
  #         # cookie = AnalyticsCookie.create(type_id: "Agent", subject_id: current_agent.id, origin_url: property_path(@property) )
  # #### => add correct cookie code here
  #         # set[:cookie] cookie.id
  #       # end
  #       if @property.active
  #         @images = @property.images.sort_by {|img| img.position }
  #         @availabilities = Availability.where( agent_id: @agent.id).where( :booked => false ).where( :start_time => { :$gte => DateTime.now } ).asc( :start_time )       
  #         @grouped_availabilities = @availabilities.all.group_by {|v| v.start_time.beginning_of_day }.values if @availabilities.any?
  #       else
  #         redirect_to root_url
  #       end
  #     end
  #   else
  #     # create an agent's page, with contact information
  #     # redirect_to @agent
  #     redirect_to root_url
  #   end
  end

  # GET /properties/new
  def new
    @property = current_agent.properties.new
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
        format.html { redirect_to edit_property_path(@property), notice: 'Property was successfully created.' }
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
      # @agency = Agency.where(name: params[:agency_id]).first
      @property = Property.find(params[:id])

      if @property.images.where(main_image: true).first
        @main_image = @property.images.where(main_image: true).first
      elsif @property.images.any?
        @main_image = @property.images.first
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:title, :description, :price, :price_unit, :property_type, :street, :postcode, :coordinates, :photo_count, :assets_uuid)
    end
end
