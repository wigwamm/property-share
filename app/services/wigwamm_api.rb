require 'singleton'


class WigwammApi

  include Singleton

  def initialize
    @uri = URI.parse("https://app.wigwamm.com/api")
    @headers = {"content-type" => "application/json"}
  end

  def post(data={})
    rsp = {}
    begin
      https = Net::HTTP.new(@uri.host, @uri.port)
      https.use_ssl = true
      response = https.post(@uri.request_uri, data.to_json, @headers)
      puts "\nwigwamm response for #{data[:method]}:\n#{response.body}"
      rsp = JSON.parse(response.body)
    rescue
      rsp
    end
  end

  def register(agent)
    data = {method: "user.new", data: {name: agent.name, email: agent.email}}
    if (response = post data) && response['error'].blank?
      agent.update_attributes passphrase: response['passphrase']
    end

    response
  end

  def login(agent)
    if agent.passphrase.nil?
      response = register(agent)
      return response unless response['error'].blank?
    end

    data = {method: "user.login", data: {email: agent.email, passphrase: agent.passphrase, persist: true}}
    if (response = post data) && response['error'].blank?
      agent.update_attributes wigwamm_auth: response['auth']
    end

    response
  end

  def stripe_pay(booking)
    agent = booking.agent
    if agent.wigwamm_auth.nil?
      response = login agent
      return response unless response['error'].blank?
    end

    data = {method: "stripe.pay", data: {auth: agent.wigwamm_auth, card_token: booking.stripe_token}}
    response = post data
  end

end