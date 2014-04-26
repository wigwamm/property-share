class Visit
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :agent
  belongs_to :user
  belongs_to :property
  belongs_to :visit
  # belongs_to :user

  field :start_time, type: Time
  field :end_time, type: Time
  field :confirmed, type: Mongoid::Boolean, default: false

  # validates :start_time, presence: true, allow_blank: false
  # validates :end_time, presence: true, allow_blank: false
  # validates :confirmed, presence: true, allow_blank: false

  validate :enough_time
  # validate :double_booked

  protected

  def valid_times
    return false unless valid_time?(:start_time, self.start_time)
    self.end_time = self.start_time + 30.minutes if self.end_time.blank?
    return false unless valid_time?(:end_time, self.end_time)
    return true
  end

  def enough_time
    if valid_times
      errors.add(:end_time, "end is before start time") unless self.start_time.utc <= self.end_time.utc - 15.minutes
    end
  end

  private

  def valid_time?(symbol, time)
    if ( time ) && ( time.is_a? Time )
      return ( time.utc >= Time.now.utc + 1.minute ? true : errors.add(symbol.to_sym, "that's in the past") )
    else
      errors.add(symbol.to_sym, "that's not a valid time")
      return false
    end
  end

end
