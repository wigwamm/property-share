class Agreement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gentleman_id,                      type: String
  field :courter_id,                        type: String, default: "app"
  field :token,                             type: String
  field :action,                            type: String
  field :args,                              type: String, default: "{}"
  field :complete,                          type: Boolean, default: false

  validates :gentleman_id, presence: true
  validates :courter_id, presence: true

  before_save :down_token
  before_save :to_s
  after_validation :setup

  def setup
    return false if errors.any? || @gentleman
    @gentleman = agent_or_user(gentleman_id)
    courter_id.downcase == "app" ? @courter = "app" : @courter = agent_or_user(courter_id)
    self.token = gen_uniq_token if self.token.blank?
    @token = self.token.upcase
    @twilio_from = "441461211042"
    @twilio_sid = "ACfae5cddc13d7602e96c1217ad6813b53"
    @twilio_token = "c9bed6ba5c12f6930aff58c9bf40ad71"
  end

  def handshake(action, args)
    if self.valid?
      # action = [action] if action.is_a? String
      args = sanatize_args(args)
      if message = setup_action(action, args)
        respond(message)
        self.args = args unless args.empty?
        self.token = @token
        save
        return true
      end
    else
      puts "Error: Invalid model"
      return false
    end
  end

  def settle(sms_subject, response)
    if self.valid?
      sms_subject == @gentleman.id.to_s ? subject = "gentleman" : subject = "courter"
      # @actions = translate_action(self.action)
      args = eval(self.args)
      args.merge! response if response
      args = sanatize_args( args )
      if message = run_action(subject, self.action, args)
        respond(message)
        save
      else
        return false
      end
    end
  end

  def activate(subject, run, args)
    activation_token = "CONFIRM"
    if run && subject == "gentleman"
      if @gentleman.activate!("mobile")
        content = "Thanks #{@gentleman.name.split(' ')[0]} you're all ready to start using Property Share."
        self.complete = true
      else
        return false
      end
    else
      @token = activation_token
      content = "Welcome to Property Share. To confirm your account, please reply #{activation_token} to this message."
    end
    return build_sms("complete", { @gentleman.mobile => content })
  end

  def setup_visit(subject, run, args)
    if args[:visit_id]
        @visit = Visit.find(args[:visit_id])
        @property = @visit.property
      if run && subject == "courter"
        @courter.activate!("mobile")
        agent_content = "Someone wants to visit #{@property.title} on #{@visit.scheduled_at.strftime("%m %b")} @ #{@visit.scheduled_at.strftime("%H:%M")}. Reply #{@token} YES to confirm, or #{@token} NO to cancel"
        user_content = "Property Share: Thanks you'll receive a confirmation text soon."
        # build sms's
        Rails.logger.debug "gentleman: #{@gentleman.mobile}"
        Rails.logger.debug "courter: #{@courter.mobile}"
        text = build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => user_content })
        # change action to confirm
        self.action = "confirm"
        return text

      else
        self.action = "setup_visit"
        user_content = "Property Share: To confirm your visit to #{@property.title} please reply #{@token} to this message"
        return build_sms("complete", { @courter.mobile => user_content })
      end
    else
      return false
    end    

  end

  def confirm(subject, run, args)
    if run
      if args[:visit_id]
        if subject == "gentleman"
          # Agent specific booking action
          @visit = Visit.find(args[:visit_id])
          @property = Property.find(@visit.property_id)
          response = args[:reply]
      
          if response.include? "yes"
      
            content = "Your visit to #{@property.title} on #{Date.tomorrow.to_formatted_s(:short)} @ 14:00 is confirmed. The address is #{@property.street}, #{@property.postcode} "
            @visit.confirm!
            self.action = "pending"
            return build_sms("complete", { @gentleman.mobile => content, @courter.mobile => content })

          elsif response.include? "no"
      
            content = "Sorry your visit to #{@property.title} on #{@visit.scheduled_at.strftime("%m %b")} @ #{@visit.scheduled_at.strftime("%H:%M")} is not possbile at, we'll contact the agent to find out more"
            # add pushover notice so we can contact the agent directly
            return build_sms("complete", { @gentleman.mobile => content, @courter.mobile => content })

          elsif response.include? "change"
      
            @time = response.match(/\d{2}:\d{2}/)[0]
            @short_date = response.match(/\/\d{2}\/\d{2}/)[0]
            @long_date = response.match(/\d{2}\/\d{2}\/\d{2}/)[0]

          else
      
            content = "Sorry you didn't include a respone, text #{@token} yes to confirm"
            return build_sms("complete", { @gentleman.mobile => content})

          end
        elsif subject == "courter"

        end
          # User specific booking action
      end
    end
  end

  def pending(subject, run, args)
    if run
      if args[:visit_id]
        if subject == "gentleman"
          if response.include? "cancel"
            # setup response to cancel
          elsif response.include? "delay"
            # setup response to delay
          elsif response.include? "change"
            # setup response to change            
          elsif response.include? "reminder"
            # setup response to reminder
          end
        end
      end
    end
  end

  def reminder(subject, run, args)
    if args[:visit_id]
      @visit = Visit.find(args[:visit_id])
      @property = Property.find(@visit.property_id)
      if run
        response = args[:reply]
        if subject == "courter"
          if response.include? "yes"
            agent_content = "Your #{@visit.scheduled_at.strftime("%H:%M")} visit to #{@property.street} just confirmed. Any problems? Reply #{@token} CANCEL/DELAY 5 "
            return build_sms("complete", { @gentleman.mobile => agent_content })
          elsif response.include? "no"
            agent_content = "Sorry your #{@visit.scheduled_at.strftime("%H:%M")} visit to #{@property.street}, #{@property.postcode} just canceled."
            user_content = "Sorry to hear that, we'll let the agent know. Thanks for using Property Share"
            self.action = "canceled"
            self.complete = true
            return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => user_content })
          end
        else subject = "gentleman"
          if response.include? "cancel"
            user_content = "Sorry your #{@visit.scheduled_at.strftime("%H:%M")} visit to #{@property.street}, #{@property.postcode} just canceled."
            agent_content = "Sorry to hear that, we'll let them know. Thanks for using Property Share"
            self.action = "canceled"
            self.complete = true
            return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => user_content })
          elsif response.include? "delay"
            how_long = response.split("delay ")[1].match(/\d*/)[0]
            user_content = "Sorry your agent is running #{how_long} minutes late."
            return build_sms("complete", { @courter.mobile => user_content })
          end
        end
      else
        user_content = "Everything still ok for your visit to #{@property.street}, #{@property.postcode} at #{@visit.scheduled_at.strftime("%H:%M") }? Reply #{@token} YES/NO "
        self.action = "reminder"
        return build_sms("complete", { @courter.mobile => user_content })
      end
    end
  end

  def checkin(subject, run, args)

  end

  private

  def sanatize_args(args)
    clean_args = {}
    binding.pry
    args.each {|k, v| clean_args.merge! k.to_sym => v.to_s }
    return clean_args
  end

  def to_s
    self.gentleman_id = self.gentleman_id.to_s
    self.courter_id = self.courter_id.to_s
  end

  def down_token
    self.token.downcase!
  end

  def format_action(array)
    s = ""
    array.each {|a| s << a + ","}
    return s
  end

  # def translate_action(string)
  #   return string.split(",")
  # end

  def respond(responses)
    responses.each do |response_k, response_v|
      if response_v[:messages]
        response_v[:messages].each do |message|
          @twilio_client = Twilio::REST::Client.new @twilio_sid, @twilio_token
          @twilio_client.account.messages.create(
            from: @twilio_from, 
            to: message[:to], 
            body: message[:content]
          )
        end
      end
    end
  end

  def build_sms(status, messages)
    reply = { :status => status, :messages => [] }
    messages.each { |to, content| reply[:messages] << { :to => to, :content => content } }
    return reply
  end

  def setup_action(action, args)
    responses = {}
    subject = "none"
    # action.each do |action|
    #   if respond_to? action
    #     response = send(action, subject, false, args)
    #     responses.merge! action.to_sym => response
    #     self.action = action 
    #   else
    #     return false
    #   end
    # end
    if respond_to? action
      response = send(action, subject, false, args)
      responses.merge! action.to_sym => response
      self.action = action 
    else
      return false
    end
    return responses
  end  

  def run_action(subject, action, args)
    responses = {}
    # actions.each do |action|
    #   if respond_to? action
    #     response = send(action, subject, true, args)
    #     responses.merge! action.to_sym => response
    #   else
    #     return false
    #   end
    # end
    if respond_to? action
      response = send(action, subject, true, args)
      responses.merge! action.to_sym => response
    else
      return false
    end
    return responses
  end

  def agent_or_user(search_id)
    Agent.where(id: search_id).first || User.where(id: search_id).first
  end

  def gen_uniq_token
    uniq = false
    # token = 1
    while uniq != true do
      token = new_token(2)
      uniq = true unless Agreement.where(gentleman_id: @gentleman.id).where(token: token).first
      # token += 1
    end
    return token
  end

  def new_token(*args)
    args.first ? num = args.first.to_i : num = 3
    # o = [('a'..'z'), ('0'..'9')].map { |i| i.to_a }.flatten # Alphanumeric
    # o = [('a'..'z')].map { |i| i.to_a }.flatten # Alpha
    o = [('0'..'9')].map { |i| i.to_a }.flatten # Numeric
    return (0...num).map { o[rand(o.length)] }.join
  end

end