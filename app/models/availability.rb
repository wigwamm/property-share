class Availability
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :agent

  attr_accessor :start_date, :end_date

  field :start_time,  type: Time, default: (Time.now + 30.minutes).round_off
  field :end_time,    type: Time
  field :booked,      type: Mongoid::Boolean, default: false

  field :created_by,  type: String, default: "webclient"
  field :updated_by,  type: String, default: "webclient"

  before_validation :build_end_time
  # before_create :assign_creator

  validates :agent_id, presence: true, allow_blank: false
  validates :start_time, presence: true, allow_blank: false
  validates :end_time, presence: true, allow_blank: false
  validates :booked, presence: true, allow_blank: false

  validate :valid_times
  validate :double_booked

  # before_validation :join_time

  def book!
    self.update_attribute(:booked, true)
  end

  protected

  def valid_times
    valid = valid_start ? valid_end : errors.add(:base, "invalid times")
    return valid
  end

  def valid_start
    unless self.start_time.is_a? Time
      errors.add(:start_time, "is not a valid time format")
      return false 
    end
    valid = self.start_time > Time.now ? true : errors.add(:start_time, "that time is in the past")
    return valid
  end

  def build_end_time
    self.end_time = self.start_time + 30.minutes if self.start_time && self.end_time == nil
  end

  def valid_end
    unless self.end_time.is_a? Time
      errors.add(:end_time, "is not a valid time format")
      return false 
    end
    valid = self.end_time > self.start_time ? true : errors.add(:end_time, "end time needs to be after start time")
    return valid
  end

  def double_booked
    errors.add(:base, "there is already an availability for that time") if self.agent.available_between(self.start_time, self.end_time)
  end

  private

  def assign_creator
    # Implement code to see where the creation came from, text, background, http
  end
  def assign_editor
    # Implement code to see where the edit came from, text, background, http
  end


  class << self
    def serialize_from_session(key, salt)
      record = to_adapter.get(key[0].to_param)
      record if record && record.authenticatable_salt == salt
    end
  end
end
