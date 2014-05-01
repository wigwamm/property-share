class AvailabilitiesController < ApplicationController
  before_action :authenticate_agent!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_agent, only: [:show]
  before_action :build_calendar, only: [:show]
  before_action :set_availability, only: [:edit, :update, :destroy]

  # GET /availabilities
  # GET /availabilities.json
  def index
    # Just show availabilites for the current agent
    @availabilities = Availability.all
  end

  # GET /availabilities/1
  # GET /availabilities/1.json
  def show
    @availability = @agent.availabilities.find(params[:id])
  end

  # GET /availabilities/new
  def new
    @availability = current_agent.availabilities.new
  end

  # GET /availabilities/1/edit
  def edit
  end

  # POST /availabilities
  # POST /availabilities.json
  def create
    @availability = current_agent.availabilities.new(availability_params)
    respond_to do |format|
      if @availability.save
        @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now }).asc(:available_at)
        @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
        format.html { redirect_to agent_availabilities_path(current_agent), notice: 'Availability was successfully created.' }
        format.js
       # format.json { render action: 'show', status: :created, location: @availability }
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  # PATCH/PUT /availabilities/1
  # PATCH/PUT /availabilities/1.json
  def update
    respond_to do |format|
      # binding.pry
      if @availability.update_attributes(availability_params)
        format.html { redirect_to @availability, notice: 'Availability was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.json
  def destroy
    @availability.destroy
    respond_to do |format|
      format.html { redirect_to availabilities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:agent_id])
    end

    def set_availability
      @agent = current_agent
      @availability = @agent.availabilities.find(params[:id])
    end

    def build_calendar
      @next_7 = @property.agent.availabilities.where( :booked => false )
                                              .where( :end_time.gte => Time.now )
                                              .where( :start_time.lte => Time.now + 7.days)
      @cal = {}
      7.times do |i| 
        d = Date.parse((Time.now + i.days).to_s)
        @cal[d] = {date: d, results: []}
      end
      @next_7.each do |av|
        date = Date.parse(av.start_time.to_s)
        @cal[date][:results] << {time: av.start_time, type: av.class, obj: av }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def availability_params
      params.require(:availability).permit(:agent_id, :start_time, :end_time, :booked, :created_by, :updated_by)
    end
end
