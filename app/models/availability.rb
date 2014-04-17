class Availability
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :agent

  attr_accessor :start_date, :end_date

  field :start_time,  type: Time
  field :end_time,    type: Time
  field :booked,      type: Mongoid::Boolean, default: false

  field :created_by,  type: String, default: "webclient"
  field :updated_by,  type: String, default: "webclient"

  before_validation :build_end_time
  before_create :assign_creator

  validate :valid_times
  # validate :agent_available?

  validates :start_time, presence: true, allow_blank: false
  validates :end_time, presence: true, allow_blank: false
  validates :booked, presence: true, allow_blank: false

  # before_validation :join_time

  def book!
    self.booked = true
    save
  end

  protected

  def valid_times
    valid = start_time if valid_start
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

  def valid_end
    unless self.end_time.is_a? Time
      errors.add(:end_time, "is not a valid time format")
      return false 
    end
    valid = self.end_time > self.start_time ? true : errors.add(:end_time, "end time needs to be after start time")
    return valid
  end

  private

  def assign_creator
    # Implement code to see where the creation came from, text, background, http
  end
  def assign_editor
    # Implement code to see where the edit came from, text, background, http
  end

  def build_end_time
    self.end_time = self.start_time + 30.minutes if self.start_time && self.end_time.blank?
  end

  # def join_time
  #   unless self.available_at
  #     split = self.time.split(":") 
  #     split[0] = "0" + split[0] if split[0].length == 1
  #     self.time = split.join(":")
  #     if self.time.length == 5 
  #       self.available_at = DateTime.parse(self.date << self.time.gsub(":", "") << "00")
  #     else
  #       errors.add(:base, "Sorry Time needs to be in 24h format")
  #     end
  #   end
  # end  

end
