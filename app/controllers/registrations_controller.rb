class RegistrationsController < Devise::RegistrationsController
  before_filter :agency, only: [:create]
  after_filter :confirm_mobile, only: [:create, :update]



  def confirm_mobile
    if self.persisted? || self.mobile_changed? # Agent/User has been created
      @agreement = Agreement.new(gentleman_id: self.id)
      activate_args = { agreement_id: @agreement.id.to_s, action: "activate" }
      Resque.enqueue(BackroomAgreement, "handshake", activate_args)
    end
  end

  def agency
    binding.pry
    params 
  end

end