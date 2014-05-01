class Visitor
  include Mongoid::Document
  include Mongoid::Timestamps
  # has_many :visits

  field :mobile,                    type: String
  field :mobile_active,             type: Mongoid::Boolean, default: false
  field :mobile_activated_at,       type: Time
  field :canceled,                  type: Integer

  field :conversion_property,       type: String
  field :referal_id,                type: String

  field :name,                      type: String
  field :first_name,                type: String
  field :last_name,                 type: String
  field :other_names,               type: String

  before_validation :format_mobile

  validates :mobile, presence: true, uniqueness: true, allow_blank: false
  validates_format_of :mobile, with: /(\+|\d)[0-9]{7,16}/

  def activate!(channel)
    attrs = { "#{channel}_active".to_sym => true,
              "#{channel}_activated_at".to_sym => Time.now.utc
          }
    self.update_attributes(attrs)
  end

  protected

  private

  def format_mobile
    if self.mobile.blank?
      return false
    else
      self.mobile.gsub!(/[^\d\+]/,'')
      self.mobile = "+44" + self.mobile[1..-1] if self.mobile[0..1] == "07"
      self.mobile = "+" + self.mobile[0..-1] if self.mobile[0..1] == "44"
      self.mobile = "+44" + self.mobile[4..-1] if self.mobile[0..3] == "0044"
    end
  end

end
