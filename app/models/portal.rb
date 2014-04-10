class Portal
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :agency
  has_one :portal_authentication

  has_many :rightmove_properties

  field :name,            	      type: String
  field :description,             type: String
  field :branch_id,               type: Integer
  field :host,                    type: String
  field :port,                    type: String
  field :services,                type: Hash,   default: Hash.new

  validates_presence_of :name, :description, :host, :port, :services, :branch_id
  validates_uniqueness_of :branch_id

end
