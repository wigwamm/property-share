require 'set'
class TextsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :agent_or_user
  
  def direct
    @message = params['Body'].downcase
    message = Set.[](*params['Body'].downcase.split(' '))
    commands = TextsController.action_methods
    command = message.intersection(commands)
    if command.any? 
      self.send(command.first)
    else
      self.send(agreements)
    end
  end

  def properties
    if @subject.class == Agent
      act_prop = []
      message_prop = []
      @subject.properties.active.each_with_index { |p, i| act_prop << p._id.to_s ; message_prop << ((p.title.length > 16) ? "#{p.title.slice(0, 16)}..." : p.title )}
      txt_content = "Your Active Properties \n"
      message_prop.each_with_index { |msg, i| txt_content << "#{i}. #{msg}\n" }
      txt = Message.new
      txt.build(@subject.mobile => txt_content)
      txt.send
    end
  end

  def help
    restricted = ["direct", "configure_permitted_parameters"]
    commands = TextsController.action_methods.subtract restricted
    txt_content = "Availible commands: \n"
    commands.each {|c| txt_content << c.upcase << "\n"}
    txt = Message.new
    txt.build(@subject.mobile => txt_content)
    txt.send
  end

  def share
    share_regex = /(^|\A|\s)SHARE\s+\D?(?<property>\d*)\S?\s*TO\s*(?<mobile>\+?\d{9,14})/i
    matched = @message.match share_regex
    if matched
      number = format_mobile(matched[:mobile])
      property = @subject.properties.active[matched[:property].to_i]
      txt_content = "Welcome to Property Share, the simpler way to list and share property information.\n\n#{@subject.first_name} would like to share a property with you.\n\nClick #{property_url(property)} for great photos and visits."
      txt = Message.new
      txt.build(number => txt_content)
      txt.send
    end
    # SEND TO
    # info = 
  end

private

  def sorry(to, *message)
    txt = Message.new
    message ||= "Sorry that didn't work, please check your spelling or reply HELP for a list of options. Property Share."
    txt.build(to => message)
    txt.send
  end

  def agreements
    content = params['Body'].downcase
    token = content.match(/\d{2}/)[0].strip if content.match(/\d{2}/)

    if token == "help"
      # help needs to be included in the agreement module as different methods are availible at different times
      
      message = "Sorry that code doesnt seem to be valid. Property Share"
      send_message(@subject.mobile, message)

    elsif token.nil? && @subject.class == User
      # tokenless specific only to setup action and Visitor
      agreement = Agreement.where(courter_id: @subject.id).where(action: "setup_visit").where(complete: false).asc(:updated_at).first
    else
      agreement = Agreement.where(courter_id: @subject.id).where(token: token).where(complete: false).asc(:updated_at).first
      agreement = Agreement.where(gentleman_id: @subject.id).where(token: token).where(complete: false).asc(:updated_at).first unless agreement
    end

    if agreement

      agreement_args = { agreement_id: agreement.id.to_s, subject: @subject.id.to_s, args: {reply: content}}
      
      unless Resque.enqueue(BackroomAgreement, "settle", agreement_args)
        message = "Sorry that code doesnt seem to be valid. Property Share"
        send_message(@subject.mobile, message)
      end
    end
  end

  def sort_messages
    act_prop = []
    message_prop = []
    @gentleman.properties.active.each_with_index { |p, i| act_prop << p._id.to_s ; message_prop << ((p.title.length > 16) ? "#{p.title.slice(0, 16)}..." : p.title )}
    agent_content = "Your Active Properties \n"
    message_prop.each_with_index { |msg, i| agent_content << "#{i}. #{msg}\n" }
    args.merge! :properties => act_prop
    return build_sms("complete", { @gentleman.mobile => agent_content })
  end

  def agent_or_user
    params["From"] = "+44" + params['From'][1..-1] if params['From'][0..1] == "07"
    unless get_agent(params["From"]) || get_user(params["From"])
      head :not_found
    end
  end

  def get_agent(number)
    @subject = Agent.where(mobile: number).asc(:updated_at).first
  end

  def get_user(number)
    @subject = User.where(mobile: number).asc(:updated_at).first
  end

end