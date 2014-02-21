class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :edit, :update, :destroy]

  # GET /availabilities
  # GET /availabilities.json
  # def index
  #   @availabilities = current_agent.availabilities.all
  # end

  # # GET /availabilities/1
  # # GET /availabilities/1.json
  # def show
  # end

  # # GET /availabilities/new
  # def new
  #   @availability = current_agent.availabilities.new
  # end

  # # GET /availabilities/1/edit
  # def edit
  # end

  # POST /availabilities
  # POST /availabilities.json
  def create
    @availability = current_agent.availabilities.new(availability_params)
    respond_to do |format|
      if @availability.save
        @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now.beginning_of_day }).asc(:available_at)
        @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
        format.html { redirect_to @availability, notice: 'Availability was successfully created.' }
        format.js
       # format.json { render action: 'show', status: :created, location: @availability }
      else
        format.html { render action: 'new' }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /availabilities/1
  # # PATCH/PUT /availabilities/1.json
  # def update
  #   respond_to do |format|
  #     if @availability.update(availability_params)
  #       @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now.beginning_of_day }).asc(:available_at)
  #       @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?

  #       format.html { redirect_to @availability, notice: 'Availability was successfully updated.' }
  #       format.js
  #       # format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @availability.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.json
  def destroy
    @availability.destroy
    respond_to do |format|
      @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now.beginning_of_day }).asc(:available_at)
      @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
      format.html { redirect_to availabilities_url }
      format.js
      # format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_availability
      @availability = current_agent.availabilities.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def availability_params
      params.require(:availability).permit(:time, :date, :available_at, :booked, :duration)
    end
end
