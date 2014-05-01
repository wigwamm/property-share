class CalendarController < ApplicationController
  before_action :set_agent, only: [:show]
  # before_action :set_property, only: [:property]
  # before_action :set_agent, only: [:agent]

  def show
    @availabilities = @agent.availabilities.where( :start_time => { :$gte => DateTime.now } ).asc( :start_time )
    @past_availabilities = @agent.availabilities.where( :end_time => { :$lte => DateTime.now } ).desc( :end_time )
    @visits = @agent.visits.where( :start_time => { :$gte => DateTime.now } ).asc( :start_time )
    @past_visits = @agent.visits.where( :end_time => { :$lte => DateTime.now } ).desc( :end_time )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      if params[:agent_id]
        @subject = @agent = Agent.find(params[:agent_id])
      elsif params[:property_id]
        @subject = Property.find(params[:property_id])
        @agent = @subject.agent
      else
        redirect_to root_path
      end
    end

end
