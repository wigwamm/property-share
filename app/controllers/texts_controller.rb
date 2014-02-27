class TextsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :agent_or_user

  def incoming
    @content = params['Body'].downcase
    if @content.match(/confirm/)
      @token = "confirm"
    else
      @token = @content.match(/\d{2}/)[0].strip
    end
    # Need to distinguish between gentleman and courter
    @agreement = Agreement.where(gentleman_id: @gentleman.id).where(token: @token).where(complete: false).first
    @agreement = Agreement.where(courter_id: @gentleman.id).where(token: @token).where(complete: false).first unless @agreement
    if @agreement
      Resque.enqueue(AgreementSettle, @agreement.id.to_s, @gentleman.id.to_s, {reply: @content})
      # response = @agreement.settle(@gentleman.id, {reply: @content})
      # return true
    else
      @twilio_from = "441461211042"
      @twilio_sid = "ACfae5cddc13d7602e96c1217ad6813b53"
      @twilio_token = "c9bed6ba5c12f6930aff58c9bf40ad71"

      @twilio_client = Twilio::REST::Client.new @twilio_sid, @twilio_token
      @twilio_client.account.messages.create(
        from: @twilio_from, 
        to: @gentleman.mobile, 
        body: "Sorry that code doesnt seem to be valid. Property Share"
      )
      # return false
    end
  end


private

  def agent_or_user
    params["From"] = "+44" + params['From'][1..-1] if params['From'][0..1] == "07"
    unless get_agent(params["From"]) || get_user(params["From"])
      head :not_found
    end
  end

  def get_agent(number)
    @gentleman = Agent.where(mobile: number).first
  end

  def get_user(number)
    @gentleman = User.where(mobile: number).first
  end

end