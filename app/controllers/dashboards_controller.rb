class DashboardsController < ApplicationController

  def agent
    @properties = current_agent.properties
    @visits = current_agent.visits
    @availabilities = Availability.where(agent_id: current_agent.id).asc(:available_at)
    @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
    @last_today = @availabilities.where( :available_at => { 
      :$gte => DateTime.now.beginning_of_day, 
      :$lte => DateTime.now.end_of_day } 
    ).desc(:available_at).first
    if @last_today
      time = Time.parse((@last_today.available_at + 29.minutes).to_s)
      @availability = current_agent.availabilities.new(time: time.round_off(30.minutes).strftime("%H:%M"))
    else
      @availability = current_agent.availabilities.new(time: Time.now.round_off(30.minutes).strftime("%H:%M"))
    end
  end

end
