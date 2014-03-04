class StaticPagesController < ApplicationController

  def home

  end

  def properties
  end

  def property
    @property = Property.last
    @agent = @property.agent
    @availabilities = Availability.where( :available_at => { :$gte => DateTime.now } ).asc( :available_at )
    @grouped_availabilities = @availabilities.all.group_by{|v| v.available_at.beginning_of_day }.values if @availabilities.any?
  end

  def form_play
    @visit = Visit.new
    @availability = Availability.new
    @user = User.new
  end

  def about

  end

end