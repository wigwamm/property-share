class StaticPagesController < ApplicationController

  def home

  end

  def properties
    @property = Property.last
    @agent = @property.agent
  end

  def property

  end

  def form_play
    @visit = Visit.new
    @availability = Availability.new
    @user = User.new
  end

  def about

  end

end