class SessionsController < Devise::SessionsController
  before_filter :format_mobile, :only => :create

  protected

  def format_mobile
    params["agent"]["mobile"].gsub!(/[^\d\+]/,'')
    params["agent"]["mobile"] = "+44" + params["agent"]["mobile"][1..-1] if params["agent"]["mobile"][0..1] == "07"
  end
end