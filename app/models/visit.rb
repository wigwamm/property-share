class Visit
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  belongs_to :agent
  belongs_to :property
  belongs_to :availability

  attr_accessor :time, :date

  field :scheduled_at,      type: DateTime
  field :reminder_sent,     type: Boolean, default: false
  field :confirmed,         type: Boolean, default: false
  
  before_save :add_agent
  before_save :set_time

  validates :scheduled_at, presence: true
  validates :user_id, presence: true
  validates :property_id, presence: true

  def add_agent
    self.agent_id = self.property.agent.id
  end

  def confirm!
    attrs = {confirmed: true}
    self.update_attributes(attrs)
  end

  def set_time
    self.scheduled_at = Availability.where(:id => self.availability_id).first.available_at
  end

end
