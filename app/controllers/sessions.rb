class SessionsController < Devise::SessionsController
  after_filter :confirm_mobile, :only => :create

  protected

  def confirm_mobile
    if resource.persisted? # Agent/User has been created
      @agreement = Agreement.new(gentleman_id: resource.id)
      @agreement.handshake("activate")
    end
  end
end