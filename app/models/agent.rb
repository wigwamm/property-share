class Agent
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :properties, dependent: :delete
  has_many :availabilities, dependent: :delete
  has_many :visits

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:mobile]

  field :name,                      type: String
  field :first_name,                type: String
  field :last_name,                 type: String, :default => ""
  field :other_names,               type: String, :default => ""
  field :email,                     type: String, :default => ""
  field :mobile,                    type: String, :default => ""
  field :primary_contact,           type: String, default: "mobile"

  field :agency,                    type: String
  field :twitter,                   type: String

  ## Database authenticatable
  field :encrypted_password,        type: String, :default => ""
  field :reset_password_token,      type: String
  field :reset_password_sent_at,    type: Time
  field :remember_created_at,       type: Time
  field :sign_in_count,             type: Integer, :default => 0
  field :current_sign_in_at,        type: Time
  field :last_sign_in_at,           type: Time
  field :current_sign_in_ip,        type: String
  field :last_sign_in_ip,           type: String

  field :mobile_active,             type: Boolean, default: false
  field :mobile_activated_at,       type: Time

  field :email_active,              type: Boolean, default: false
  field :email_activation_code,     type: String
  field :email_activated_at,        type: Time


  before_create :make_activation_codes
  before_save :format_name
  before_validation :format_mobile
  after_create :confirm_mobile


  validates :name, presence: true
  validates :mobile, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, allow_blank: true
  validates_format_of :email, :with => /@/, :allow_blank => true
  validates_format_of :mobile, with: /(\+|\d)[0-9]{7,16}/
  
  validate :email_or_phone

  def activate!(channel)
    attrs = { "#{channel}_active".to_sym => true,
              "#{channel}_activated_at".to_sym => Time.now.utc
          }
    self.update_attributes!(attrs)
  end

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login).downcase
  #     binding.pry
  #     where(conditions).where('$or' => [ {:mobile => /^#{Regexp.escape(login)}$/i}, {:email => /^#{Regexp.escape(login)}$/i} ]).first
  #   else
  #     where(conditions).first
  #   end
  # end 
  
  protected

  def confirm_mobile
    if self.persisted? # Agent/User has been created
      @agreement = Agreement.new(gentleman_id: self.id)
      @agreement.handshake("activate")
    end
  end

  def make_activation_codes
    self.email_activation_code = self.class.make_token
  end

  private

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
    names = self.name.split(" ")
    self.first_name = names[0]
    self.other_names = names[1..-2].join(" ") if names.count >= 3
    self.last_name = names[-1] if names.count >= 2
  end

  def format_mobile
    self.mobile.gsub!(/[^\d\+]/,'')
    self.mobile = "+44" + self.mobile[1..-1] if self.mobile[0..1] == "07"
  end

  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def self.make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

end
