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

  def book!
    self.booked = true
    save
  end

  private

  def agent_available?
    unless self.booked
      if self.available_at
        availabilities = self.agent.availabilities
        taken = availabilities.where( :available_at => { 
          :$gte => self.available_at - (30.minutes) + 1.second, 
          :$lte => self.available_at } 
        ).first
        errors.add(:base, "Sorry it looks like your already booked then") if taken
      end
    end
  end

  def join_time
    unless self.available_at
      split = self.time.split(":") 
      split[0] = "0" + split[0] if split[0].length == 1
      self.time = split.join(":")
      if self.time.length == 5 
        self.available_at = DateTime.parse(self.date << self.time.gsub(":", "") << "00")
      else
        errors.add(:base, "Sorry Time needs to be in 24h format")
      end
    end
  end  

end
