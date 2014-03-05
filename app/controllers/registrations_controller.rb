class RegistrationsController < Devise::RegistrationsController
  before_filter :agency, only: [:new]
  after_filter :confirm_mobile, only: [:create, :update]

  def confirm_mobile
    if resource.persisted? || resource.mobile_changed? # Agent/User has been created
      @agreement = Agreement.new(gentleman_id: resource .id)
      activate_args = { agreement_id: @agreement.id.to_s, action: "activate" }
      Resque.enqueue(BackroomAgreement, "handshake", activate_args)
    end
  end

  def agency
    @agency = Agency.where(registration_code: params[:token]).where(name: params[:agency]).first
    redirect_to root_path unless @agency
  end

end