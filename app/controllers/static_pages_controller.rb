class StaticPagesController < ApplicationController

  def home
    flash[:message] = true
  end

  def about
  end

  def pricing
  end

  def contact
  end

  def hiring
  end

end
