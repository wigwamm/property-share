class Agent
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :availabilities
  has_many :shares

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :type,                      type: String
  field :admin,                     type: Mongoid::Boolean
  field :canceled,                  type: Integer

  field :name,                      type: String
  field :first_name,                type: String
  field :last_name,                 type: String, :default => ""
  field :other_names,               type: String, :default => ""
  
  field :registration_code,         type: String

  ## Database authenticatable
  field :mobile,                    type: String, default: ""
  field :mobile_active,             type: Mongoid::Boolean, default: false
  field :mobile_activated_at,       type: Time
  field :encrypted_password,        type: String, default: ""

  field :email,                     type: String
  field :primary_contact,           type: String, default: "mobile"

  ## Recoverable
  field :reset_password_token,      type: String
  field :reset_password_sent_at,    type: Time

  ## Rememberable
  field :remember_created_at,       type: Time

  ## Trackable
  field :sign_in_count,             type: Integer, default: 0
  field :current_sign_in_at,        type: Time
  field :last_sign_in_at,           type: Time
  field :current_sign_in_ip,        type: String
  field :last_sign_in_ip,           type: String

  ## Confirmable
  # field :confirmation_token,      type: String
  # field :confirmed_at,            type: Time
  # field :confirmation_sent_at,    type: Time
  # field :unconfirmed_email,       type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts,         type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,            type: String # Only if unlock strategy is :email or :both
  # field :locked_at,               type: Time

  field :twitter,                   type: String
  field :facebook,                  type: String

#  before_create :check_registration_code
  after_validation :format_name
  before_validation :format_mobile

  validates :name, presence: true
  validates :registration_code, presence: true, allow_blank: false
  
  validates :mobile, presence: true, uniqueness: true, allow_blank: false

  validates :email, presence: true, uniqueness: true, allow_blank: true
  
  validates_format_of :email, with: /@/,  allow_blank: true
  validates_format_of :mobile, with: /(\+|\d)[0-9]{7,16}/
  
  validate :email_or_phone

  def activate!(channel)
    attrs = { "#{channel}_active".to_sym => true,
              "#{channel}_activated_at".to_sym => Time.now.utc
          }
    self.update_attributes!(attrs)
  end

  def todays_availabilities
    @todays_availabilities = self.availabilities.where( :start_time => { :$gte => Time.now, :$lte => Date.tomorrow.to_time } ).where(:booked => false)
    response = @todays_availabilities.any? ? @todays_availabilities : errors.add(:messages, " there are no availabilities today")
    return response
  end

  def next_availability
    todays_availabilities unless @todays_availabilities
    if @todays_availabilities.any?
      @next_availability = @todays_availabilities.order_by( :start_time.asc ).first
      return @next_availability
    else
      availabilities = availabilities_after(Time.now)
      response = availabilities.any? ? availabilities : errors.add(:messages, "sorry this person has no active availabilities")
      return response
    end
  end

  def availabilities_after(time)
    if time < Time.now
      errors.add(:messages, "no availabilities, please try another time")
    else
      availabilities = self.availabilities.where( :start_time.gte => time )
      response = availabilities.any? ? availabilities.order_by(:start_time.asc) : errors.add(:messages, "sorry there are no availabilities available")
      return response
    end
  end

  def availabilities_before(time)
    if time < Time.now
      errors.add(:messages, "no availabilities, please try another time")
    else
      availabilities = self.availabilities.where( :start_time.gte => Time.now)
                                          .where( :start_time.lte => time )
      response = availabilities.any? ? availabilities.order_by(:start_time.asc) : errors.add(:messages, "sorry there are no availabilities available")
      return response
    end
  end

  def available?
    return available_between(Time.now, Time.now + 30.minutes)
  end

  def available_in(time_added)
    return available_between(Time.now, Time.now + time_added)
  end

  def available_between(start_time, end_time)
    if( (start_time.is_a? Time) && (end_time.is_a? Time) )
      availabilities = self.availabilities.where(:booked => false)
                                          .where( :start_time.lte => end_time)
                                          .where( :end_time.gte => start_time )
      response = availabilities.any? ? availabilities.order_by(:start_time.asc) : false
      return response
    else
      errors.add(:base, "Sorry they're not valid times")
      return false
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:mobile] = format_mobile_number(conditions[:mobile])
    if mobile = conditions.delete(:mobile).downcase
      where(conditions).where('$or' => [ {:mobile => /^#{Regexp.escape(mobile)}$/i}, {:email => /^#{Regexp.escape(mobile)}$/i} ]).first
    else
      where(conditions).first
    end
  end 

  def self.format_mobile_number(mobile)
    if mobile.blank?
      return false
    else
      mobile.gsub!(/[^\d\+]/,'')
      mobile = "+44" + mobile[1..-1] if mobile[0..1] == "07"
      mobile = "+" + mobile[0..-1] if mobile[0..1] == "44"
      mobile = "+44" + mobile[4..-1] if mobile[0..3] == "0044"
      return mobile
    end
  end
  
  protected

  def check_registration_code
    if self.type == "Agent"
      agency = Agency.where(registration_code: self.registration_code).first
      self.registration_code == agency.registration_code
    end
  end

  def email_required?
    false
  end

  def email_or_phone
    if self.primary_contact == "email"
      errors.add(:base, "You need to enter an email") if self.email.blank?
    elsif self.primary_contact == "mobile"
      errors.add(:base, "you need to enter a mobile") if self.mobile.blank?
    end
  end

  def format_name
    unless self.name.blank?
      names = self.name.gsub(/\s+/m, " ").split(" ")
      self.first_name = names[0]
      self.other_names = names[1..-2].join(" ") if names.count >= 3
      self.last_name = names[-1] if names.count >= 2
    end
  end

  def format_mobile
    self.mobile = Agent.format_mobile_number(self.mobile) unless self.email.blank?
  end

  private

  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def self.make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

end
