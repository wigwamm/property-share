class CookiesController < ApplicationController

  def set
    if params[:c] == "true"
      cookies.permanent[:agreed] = { value: params[:v] + "_" + params[:c] }
      render :text => "success"
    else
      cookies[:agreed] = { value: params[:v] + "_" + params[:c] , expires: params[:t].to_i.from_now }
      render :text => "success"
    end
  end

end