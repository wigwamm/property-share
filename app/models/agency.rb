class Agency
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :agents
  has_many :properties

  field :name, type: String
  field :contact, type: String
  field :email, type: String
  field :phone, type: String
  field :notes, type: String

  field :registration_code, type: String
  field :registration_code_created, type: DateTime

  field :agency_size, type: String
  field :activated, type: Boolean

  before_validation :format_phone
  before_save :format_name

  validates :name, presence: true, uniqueness: true
  validates :contact, presence: true
  validates :phone, presence: true, uniqueness: true
  validates_format_of :email, :with => /@/, :allow_blank => true
  validates_format_of :phone, with: /(\+|\d)[0-9]{7,16}/

  def to_param
    name
  end


  def activate!
    attrs = {registration_code_created: DateTime.now, registration_code: self.class.make_token, activated: true}
    self.update_attributes!(attrs)
  end

  def refresh!
    attrs = {registration_code_created: DateTime.now, registration_code: self.class.make_token}
    self.update_attributes!(attrs)
  end

  protected

  def format_name
    self.name = self.name.gsub(/\ /, "-").downcase
  end

  def format_phone
    self.phone = Agency.format_phone_number(self.phone)
  end

  def self.format_phone_number(phone)
    phone.gsub!(/[^\d\+]/,'')
    phone = "+44" + phone[1..-1] if phone[0] == "0"
    phone = "+" + phone[0..-1] if phone[0..1] == "44"
    phone = "+44" + phone[4..-1] if phone[0..3] == "0044"
    return phone
  end

  def format_mobile
    self.mobile = Agency.format_mobile_number(self.mobile)
  end

  def self.format_mobile_number(mobile)
    mobile.gsub!(/[^\d\+]/,'')
    mobile = "+44" + mobile[1..-1] if mobile[0..1] == "07"
    mobile = "+" + mobile[0..-1] if mobile[0..1] == "44"
    mobile = "+44" + mobile[4..-1] if mobile[0..3] == "0044"
    return mobile
  end

  private

  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def self.make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end


end
