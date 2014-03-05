class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:destroy]

  # POST /availabilities
  # POST /availabilities.json
  def create
    @availability = current_agent.availabilities.new(availability_params)
    respond_to do |format|
      if @availability.save
        @availabilities = Availability.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now }).asc(:available_at)
        @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
        format.html { redirect_to @availability, notice: 'Availability was successfully created.' }
        format.js
       # format.json { render action: 'show', status: :created, location: @availability }
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

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
