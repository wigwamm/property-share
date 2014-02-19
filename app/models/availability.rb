class Availability
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :agent
  attr_accessor :time, :date

  field :available_at, type: DateTime
  field :booked, type: Boolean, default: false
  field :duration, type: Integer, default: 30

  before_validation :join_time

  validates :available_at, presence: true  
  validate :agent_available?

  private

  def agent_available?
    availabilities = self.agent.availabilities
    taken = availabilities.where( :available_at => { 
      :$gte => self.available_at - (30.minutes) + 1.second, 
      :$lte => self.available_at } 
    ).first
    errors.add(:base, "Sorry it looks like your already booked then") if taken
  end

  def join_time
    self.available_at = DateTime.parse(self.date << self.time.gsub(":", "") << "00") unless self.available_at
  end  

end
