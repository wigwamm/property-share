class User
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :visits

  field :mobile,                    type: String
  field :name,                      type: String
  field :mobile_active,             type: Boolean, default: false
  field :mobile_activated_at,       type: Time

  before_save :format_mobile

  def activate!(channel)
    attrs = { "#{channel}_active".to_sym => true,
              "#{channel}_activated_at".to_sym => Time.now.utc
          }
    self.update_attributes(attrs)
  end

  protected

  private

  def format_mobile
    self.mobile = "+44" + self.mobile[1..-1] if self.mobile[0..1] == "07"
  end

end
