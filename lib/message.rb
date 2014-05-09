class Message

  def initialize()
    twilio = YAML.load(ERB.new(File.read("#{Rails.root}/config/twilio.yml")).result)[Rails.env].symbolize_keys!
    @twilio_from = twilio[:number]
    @twilio_client = Twilio::REST::Client.new twilio[:sid], twilio[:token]
  end

  def build(messages)
    @messages = []
    messages.each { |to, content| @messages << { :to => to, :content => content } }
    return @messages
  end

  def send
    @messages.each do |txt|
      @twilio_client.account.messages.create( from: @twilio_from,  to: txt[:to], body: txt[:content] )
    end
  end

end