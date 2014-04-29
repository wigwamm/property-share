class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  class AccessDenied < StandardError; end

  rescue_from AccessDenied, :with => :access_denied

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :mobile, :location, :password, :password_confirmation, :remember_me, :agency_id, :registration_code)
    end
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login, :email, :mobile, :password, :remember_me)
    end
    devise_parameter_sanitizer.for(:account_update) do |u| 
      u.permit(:name, :email, :mobile, :location, :twitter, :password, :password_confirmation, :current_password)
    end
  end
  
  protected

  def format_mobile(number)
    number.gsub!(/[^\d\+]/,'')
    number = "+44" + number[1..-1] if number[0..1] == "07"
    number = "+" + number[0..-1] if number[0..1] == "44"
    number = "+44" + number[4..-1] if number[0..3] == "0044"
    return number
  end

  def format_price(number)

    return number
  end

  private

  def access_denied
    redirect_to "/401.html"
  end

end