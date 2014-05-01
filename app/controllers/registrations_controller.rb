class RegistrationsController < Devise::RegistrationsController
  # before_filter :agency, only: [:new]
  after_filter :confirm_mobile, only: [:create, :update]
  after_filter :coverted, only: [:create]

  def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @agent = Agent.find(current_agent.id)
    if @agent.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the agent bypassing validation in case his password changed
      sign_in @agent, :bypass => true
      redirect_to edit_agent_registration_path
    else
      render "edit"
    end
  end

  def converted
    cookies.permanent[:agreed] = { value: "coverted_signup" } unless cookies[:agreed] == "coverted_signup"
  end
  def confirm_mobile
    if resource.valid? && (resource.persisted? || resource.mobile_changed?) # Agent/User has been created
      @agreement = Agreement.create(gentleman_id: resource.id)
      activate_args = { agreement_id: @agreement.id.to_s, action: "agent_activate" }
      Resque.enqueue(BackroomAgreement, "handshake", activate_args)
    end
  end

end