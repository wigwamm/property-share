class SessionsController < Devise::SessionsController
  before_filter :format_mobile, :except => :destroy

  protected

  def format_mobile
    if params["agent"]
      params["agent"]["mobile"].gsub!(/[^\d\+]/,'')
      params["agent"]["mobile"] = "+44" + params["agent"]["mobile"][1..-1] if params["agent"]["mobile"][0..1] == "07"
      params["agent"]["mobile"] = "+" + params["agent"]["mobile"][0..-1] if params["agent"]["mobile"][0..1] == "44"
      params["agent"]["mobile"] = "+44" + params["agent"]["mobile"][4..-1] if params["agent"]["mobile"][0..3] == "0044"
    end
  end
end