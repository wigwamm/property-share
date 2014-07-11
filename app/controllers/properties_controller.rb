class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy, :book, :share]
  before_filter :authenticate_agent!, except: [:show]

  # GET /properties
  # GET /properties.json
  def index
    @properties = current_agent.properties.all
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    if @property
      @agent = @property.agent
      @visit = @property.visits.new(agent_id: @agent.id)
      @user = User.new
      if current_agent == @agent
        availabilities = Availability.where( agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now } ).asc( :available_at )
        last_today = availabilities.where( :available_at => { :$lte => DateTime.now.end_of_day } ).asc(:available_at).first
        last_today ? time = Time.parse((last_today.available_at + 29.minutes).to_s) : time = Time.now
        @images = @property.images.sort_by {|img| img.sort_order }
        @grouped_availabilities = availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if availabilities.any?
        @availability = current_agent.availabilities.new(time: time.round_off(30.minutes).strftime("%H:%M"))
      else
        # set tracking cookie if current_agent to see properties other agents are viewing...
        # if current_agent
          # cookie = AnalyticsCookie.create(type_id: "Agent", subject_id: current_agent.id, origin_url: property_path(@property) )
  #### => add correct cookie code here
          # set[:cookie] cookie.id
        # end
        if @property.active
          @images = @property.images.sort_by {|img| img.position }
          @availabilities = Availability.where( agent_id: @agent.id).where( :booked => false ).where( :available_at => { :$gte => DateTime.now } ).asc( :available_at )       
          @grouped_availabilities = @availabilities.all.group_by {|v| v.available_at.beginning_of_day }.values if @availabilities.any?
        else
          redirect_to root_url
        end
      end
    else
      # create an agent's page, with contact information
      # redirect_to @agent
      redirect_to root_url
    end
  end

  # GET /properties/new
  def new
    @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now.beginning_of_day }).asc(:available_at)
    @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
    @last_today = @availabilities.where( :available_at => { :$gte => DateTime.now.beginning_of_day, 
                                                            :$lte => DateTime.now.end_of_day } 
                                        ).asc(:available_at).first
    @last_today ? time = Time.parse((@last_today.available_at + 29.minutes).to_s) : time = Time.now
    @availability = current_agent.availabilities.new(time: time.round_off(30.minutes).strftime("%H:%M"))
    @property = current_agent.properties.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties
  # POST /properties.json
  def create
    puts property_params
    puts "\n"

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

  def book
  end

  def share
    @booking = @property.bookings.new(params.require(:booking).permit(:agent_id, :stripe_token))

    if @booking.save
      if @booking.wigwamm_pay
        @property.upload
        redirect_to @property, notice: 'Payment was successfull. The property will be shared soon.'
      else
        redirect_to @property, notice: @booking.errors.full_messages.join(' ')
      end
    else
      render :book
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id] || params[:property_id])
      @main_image = @property.media.images.first if @property
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params[:property][:detail_attributes][:features] = params[:property][:detail_attributes][:features].split(',')

      params.require(:property)
        .permit(:published, :status, :property_type, :let_type, :trans_type,
          address_attributes: [:id, :house_name_number, :town, :address_2, :address_3, :address_4,
            :postcode, :display_address],
          price_information_attributes: [:id, :price, :tenure_type, :tenure_unexpired_years],
          detail_attributes: [:id, :summary, :description, :bedrooms, :_destroy, features: [], 
            rooms_attributes: [:id, :room_name, :room_description, :room_width, :room_length, :room_dimension_unit, :room_photo_urls, :_destroy]],
          principal_attributes: [:id, :principal_email_address],
          media_attributes: [:id, :photo, :caption, :id, :media_type, :sort_order, :_destroy])
    end
end
