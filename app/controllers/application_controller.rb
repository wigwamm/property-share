class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  class AccessDenied < StandardError; end

  rescue_from AccessDenied, :with => :access_denied

  ########################################

  # =>  use when you want to add protected params to devise models

  # before_filter :configure_permitted_parameters, if: :devise_controller?
  # # before_filter :authenticate_agent!

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) do |u|
  #     u.permit(:name, :email, :mobile, :password, :password_confirmation, :remember_me, :agency_id, :registration_code)
  #   end
  #   devise_parameter_sanitizer.for(:sign_in) do |u|
  #     u.permit(:login, :email, :mobile, :password, :remember_me)
  #   end
  #   devise_parameter_sanitizer.for(:account_update) do |u| 
  #     u.permit(:name, :email, :mobile, :agency, :twitter, :password, :password_confirmation, :current_password)
  #   end
  # end


  ########################################

private

  def access_denied
    redirect_to "/401.html"
  end

end