class TextsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :agent_or_user

  def incoming
    content = params['Body'].downcase
    content.match(/confirm/) ?  token = "confirm" : token = content.match(/\d{2}/)[0].strip
    agreement = Agreement.where(courter_id: @gentleman.id).where(token: token).where(complete: false).asc(:updated_at).first
    agreement = Agreement.where(gentleman_id: @gentleman.id).where(token: token).where(complete: false).asc(:updated_at).first unless agreement

    if agreement
      agreement_args = { agreement_id: agreement.id.to_s, subject: @gentleman.id.to_s, args: {reply: content}}
      unless Resque.enqueue(BackroomAgreement, "settle", agreement_args)
        twilio = YAML.load_file('config/twilio.yml').with_indifferent_access[Rails.env]
        twilio_from = twilio[:number]
        twilio_sid = twilio[:sid]
        twilio_token = twilio[:token]

        twilio_client = Twilio::REST::Client.newtwilio_sid,twilio_token
        twilio_client.account.messages.create(
          from:twilio_from, 
          to: @gentleman.mobile, 
          body: "Sorry that code doesnt seem to be valid. Property Share"
        )
      end
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
    @gentleman = Agent.where(mobile: number).asc(:updated_at).first
  end

  def get_user(number)
    @gentleman = User.where(mobile: number).asc(:updated_at).first
  end

end