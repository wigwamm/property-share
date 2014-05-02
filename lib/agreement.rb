class Agreement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gentleman_id,                      type: String
  field :courter_id,                        type: String, default: "app"
  field :token,                             type: String
  field :action,                            type: String
  field :args,                              type: String, default: "{}"
  field :complete,                          type: Mongoid::Boolean, default: false
  field :expired,                           type: Mongoid::Boolean, default: false

  validates :gentleman_id, presence: true, allow_blank: false
  validates :courter_id, presence: true, allow_blank: false

  # before_save :down_token
  before_save :to_s

  validate :setup_members
  after_validation :build

  def handshake(action, args)
    if self.valid?
      args = HashWithIndifferentAccess.new(args)
      if message = setup_action(action, args)
        respond(message)
        self.args = args.to_s unless args.empty?
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
      args = eval(self.args)
      args.merge! response if response
      args = HashWithIndifferentAccess.new(args)
      if message = run_action(subject, self.action, args)
        respond(message)
        save
      else
        return false
      end
    end
  end

  protected

    def introduction(subject, run, args)
      if run && subject == "gentleman"
        response = args[:reply]
        if response.include? "activate" && @courter.activate!
          link = "http://www.propertyshare.io/agent/register?agency=#{@courter.name}&token=#{@courter.registration_code}"

          content = I18n.t( 'agreements.introduction.settle.gentleman', 
                            link: link
                            )

          self.complete = true
        else

          content = I18n.t('agreements.introduction.settle.error')

        end
      else

        content = I18n.t( 'agreements.introduction.handshake.gentleman', 
                          agent_name: args[:agency][:contact], 
                          agency_name: args[:agency][:name], 
                          agency_phone: args[:agency][:phone], 
                          token: @token 
                          )

      end
      return build_sms("complete", { @gentleman.mobile => content })
    end

    def activate(subject, run, args)

      if run && subject == "gentleman"
        if @gentleman.activate!("mobile")

          content = I18n.t( 'agreements.activate.settle.gentleman', 
                            first_name: @gentleman.name.split(' ')[0] 
                            )

          self.complete = true
        else
          return false
        end
      else
        self.action = "activate"
        @token = self.action

        content = I18n.t( 'agreements.activate.handshake.gentleman' )

      end
      return build_sms("complete", { @gentleman.mobile => content })
    end

    def agent_activate(subject, run, args)

      if run && subject == "gentleman"
        if @gentleman.activate!("mobile")

          content = I18n.t( 'agreements.agent_activate.settle.gentleman' )
          self.complete = true
        else
          return false
        end
      else
        self.action = "activate"
        @token = self.action

        content = I18n.t( 'agreements.agent_activate.handshake.gentleman' )

      end
      return build_sms("complete", { @gentleman.mobile => content })
    end

    def setup_visit(subject, run, args)
      if args[:visit_id]

        @visit = Visit.find(args[:visit_id])
        @property = @visit.property

        if run && subject == "courter"
          # actions to be carried out if the User replies

          response = args[:reply]

          if @courter.name.blank?                                   # if the user has no name i.e. is new
            @courter.name = response.strip.titleize                 # parse message for name
            @courter.activate!("mobile")                            
            @courter.save
          end

          # agent_content = "#{@courter.name} wants to visit #{@property.title}
          #                 on #{@visit.scheduled_at.strftime("%m %b @ %H:%M")}. 
          #                 To confirm reply [ #{@token} YES ] or [ #{@token} NO ]"
          agent_content = I18n.t( 'agreements.setup_visit.settle.gentleman', 
                                  visitor_name: @courter.name,
                                  property_title: @property.title,
                                  visit_time: @visit.scheduled_at.strftime("%m %b @ %H:%M")
            )

          visitor_content = "Property Share: Thanks you'll receive a confirmation text soon."
          self.action = "confirm"                                                                                       # change action to confirm
          return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => visitor_content })         # build sms's

        else
           # actions to be carried out if the User replies
          self.action = "setup_visit"

          if @courter.name.blank?

            # visitor_content = "To confirm your visit please reply [ YOUR NAME ] to confirm. Thanks Property Share." 
            visitor_content = I18n.t( 'agreements.setup_visit.handshake.courter_first_time' )

          else

            # visitor_content = "Hello #{@courter.name}. To confirm your visit to #{@property.title} please reply [ #{@token} YES ]. Thanks Property Share."
            visitor_content = I18n.t( 'agreements.setup_visit.handshake.courter', token: @token)

          end

          return build_sms("complete", { @courter.mobile => visitor_content })
        end

      else
        return false
      end    

    end

    def confirm(subject, run, args)
      if run && args[:visit_id]
        if subject == "gentleman"
          # Agent specific booking action
          @visit = Visit.find(args[:visit_id])
          @property = Property.find(@visit.property_id)
          response = args[:reply]
      
          if response.include? "confirm"
      
            #           The address is #{@property.street}, #{@property.postcode}."

            content = I18n.t( 'agreements.confirm.settle.confirm.gentleman', 
                  property_title: @property.title, 
                  property_street: @property.street, 
                  property_postcode: @property.postcode, 
                  visit_time: @visit.scheduled_at.strftime("%m %b @ %H:%M")
                  )
            visitor_content = content << " " << I18n.t( 'agreements.confirm.reminder' )

            @visit.confirm!
            self.action = "pending"
            return build_sms("complete", { @gentleman.mobile => content, @courter.mobile => visitor_content })

          elsif response.include? "cancel"
      
            # add pushover notice so we can contact the agent directly
            agent_content = I18n.t( 'agreements.confirm.settle.cancel.gentleman', 
              property_title: @property.title, 
              token: @agreement.token
              )
            visitor_content = I18n.t( 'agreements.confirm.settle.cancel.courter', 
              property_title: @property.title, 
              visit_time: @visit.scheduled_at.strftime("%m %b @ %H:%M")
              )

            @gentleman.inc(:canceled, 1)
            self.action = "canceled"
            self.complete = true

            return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => visitor_content })

          # elsif response.include? "change"
      
          #   @time = response.match(/\d{2}:\d{2}/)[0]
          #   @short_date = response.match(/\/\d{2}\/\d{2}/)[0]
          #   @long_date = response.match(/\d{2}\/\d{2}\/\d{2}/)[0]

          else
      
            content = I18n.t( 'agreements.confirm.settle.no_response', token: @token )

            return build_sms("complete", { @gentleman.mobile => content})

          end
        end
      end
    end

    def pending(subject, run, args)
      if run && args[:visit_id]
        @visit = Visit.find(args[:visit_id])
        @property = Property.find(@visit.property_id)

        if response.include? "cancel"

          visitor_content = I18n.t( 'agreements.pending.settle.cancel.courter', 
            property_title: @property.title, 
            visit_time: @visit.scheduled_at.strftime("%m %b @ %H:%M")
            )
          agent_content = I18n.t( 'agreements.pending.settle.cancel.gentleman', 
            property_title: @property.title, 
            token: @agreement.token
            )

          return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => visitor_content })

        elsif response.include? "delay"
          
          how_long = response.split("delay ")[1].match(/\d*/)[0]
          @visit.update_attribute(scheduled_at: @visit.scheduled_at + how_long.to_i.minutes )

          # visitor_content = "Sorry your agent is running #{how_long} minutes late."
          visitor_content = I18n.t( 'agreements.pending.settle.delay.courter', 
              first_name: @gentleman.first_name, 
              property_title: @property.title, 
              delay: how_long
              )

          agent_content = I18n.t( 'agreements.pending.settle.delay.gentleman' )

          return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => visitor_content })

        else
    
          content = I18n.t( 'agreements.pending.settle.no_response', token: @token )

          return build_sms("complete", { @gentleman.mobile => content})

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

              agent_content = I18n.t( 'agreements.reminder.settle.yes.gentleman', 
                    property_street: @property.street, 
                    property_postcode: @property.postcode, 
                    visit_time: @visit.scheduled_at.strftime("%m %b @ %H:%M")
                    )
              
              visitor_content = I18n.t( 'agreements.reminder.settle.yes.courter')

              agent_content = "Your #{@visit.scheduled_at.strftime("%H:%M")} visit to #{@property.street} just confirmed. Any problems? Reply [ #{@token} CANCEL/DELAY 5/DELAY 10 ]"

              return build_sms("complete", { @gentleman.mobile => agent_content })

            elsif response.include? "cancel"
              
              # agent_content = "Sorry your #{@visit.scheduled_at.strftime("%H:%M")} visit to #{@property.street}, #{@property.postcode} just canceled."
              # visitor_content = "Sorry to hear that, we'll let the agent know. Thanks for using Property Share"

              visitor_content = I18n.t( 'agreements.reminder.settle.cancel.courter', 
                property_title: @property.title, 
                visit_time: @visit.scheduled_at.strftime("%m %b @ %H:%M")
                )
              agent_content = I18n.t( 'agreements.reminder.settle.cancel.gentleman', 
                property_title: @property.title, 
                token: @agreement.token
                )

              @courter.inc(:canceled, 1)
              self.action = "canceled"
              self.complete = true

              return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => visitor_content })

            else
        
              content = I18n.t( 'agreements.reminder.settle.no_response.courter', token: @token )

              return build_sms("complete", { @courter.mobile => content})

            end
          else subject = "gentleman"

            if response.include? "cancel"

              # visitor_content = "Sorry your #{@visit.scheduled_at.strftime("%H:%M")} visit to #{@property.street}, #{@property.postcode} just canceled."
              # agent_content = "Sorry to hear that, we'll let them know. Thanks for using Property Share"

              visitor_content = I18n.t( 'agreements.reminder.settle.cancel.gentleman', 
                property_title: @property.title, 
                visit_time: @visit.scheduled_at.strftime("%m %b @ %H:%M")
                )
              agent_content = I18n.t( 'agreements.reminder.settle.cancel.courter', 
                property_title: @property.title, 
                token: @agreement.token
                )

              @gentleman.inc(:canceled, 1)
              self.action = "canceled"
              self.complete = true

              return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => visitor_content })

            elsif response.include? "delay"
              
              how_long = response.split("delay ")[1].match(/\d*/)[0]
              # visitor_content = "Sorry your agent is running #{how_long} minutes late."

              visitor_content = I18n.t( 'agreements.pending.settle.delay.courter', 
                  first_name: @courter.first_name, 
                  property_title: @property.title, 
                  delay: how_long
                  )

              agent_content = I18n.t( 'agreements.pending.settle.delay.gentleman' )

              return build_sms("complete", { @gentleman.mobile => agent_content, @courter.mobile => visitor_content })

            else
        
              content = I18n.t( 'agreements.reminder.settle.no_response.gentleman', token: @token )

              return build_sms("complete", { @gentleman.mobile => content})

            end
          end
        else

          self.action = "reminder"
          visitor_content = "Everything still ok for your visit to #{@property.street}, #{@property.postcode} at #{@visit.scheduled_at.strftime("%H:%M") }? Reply [ #{@token} YES/NO ]"
          @visit.update_attribute(:reminder_sent, true)
          return build_sms("complete", { @courter.mobile => visitor_content })
          
        end
      end
    end

    def checkin(subject, run, args)

    end

  private
  
    def setup_members
      @gentleman = find_model_by_id(gentleman_id)
      courter_id.downcase == "app" ? @courter = "app" : @courter = find_model_by_id(courter_id)
      errors.add(:base, "gentleman_id is not valid") unless @gentleman
      errors.add(:base, "courter_id is not valid") unless @courter
    end

    def build
      return false if errors.any?
      twilio = YAML.load(ERB.new(File.read("#{Rails.root}/config/twilio.yml")).result)[Rails.env].symbolize_keys!
      @twilio_from = twilio[:number]
      @twilio_sid = twilio[:sid]
      @twilio_token = twilio[:token]
      self.token = gen_uniq_token if self.token.blank?
      @token = self.token.upcase
    end

    def to_s
      self.gentleman_id = self.gentleman_id.to_s
      self.courter_id = self.courter_id.to_s
    end

    # def down_token
    #   self.token.downcase!
    # end

    def format_action(array)
      s = ""
      array.each {|a| s << a + ","}
      return s
    end

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
      if Agreement.method_defined? action
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
      if respond_to? action
        response = send(action, subject, true, args)
        responses.merge! action.to_sym => response
      else
        return false
      end
      return responses
    end

    def find_model_by_id(search_id)
      Agent.where(id: search_id).first || Visitor.where(id: search_id).first
    end

    def gen_uniq_token
      uniq = false
      while uniq != true do
        token = new_token(2)
        uniq = true unless Agreement.where(gentleman_id: @gentleman.id).where(token: token).first
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

  class << self
    def serialize_from_session(key, salt)
      record = to_adapter.get(key[0].to_param)
      record if record && record.authenticatable_salt == salt
    end
  end
end