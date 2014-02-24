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
  after_create :confirm_visit
  after_update :update_visit

  validates :scheduled_at, presence: true
  validates :user_id, presence: true
  validates :property_id, presence: true

  def add_agent
    self.agent_id = self.property.agent.id
  end

  def confirm_visit
    if self.persisted?
      @agreement = Agreement.new(gentleman_id: self.agent_id, courter_id: self.user_id)
      @agreement.handshake("setup_visit", {visit_id: self.id})
    end
  end

  def set_time
    self.scheduled_at = Availability.where(:id => self.availability_id).first.available_at
  end

  def update_visit
    # if self.persisted
    #   @agreement = Agreement.where(visit_id: self.id)
    #   @agreement.handshake("update_visit", visit_id: self.id)
    # end
  end

end
