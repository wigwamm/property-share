class Portal
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :agency
  has_one :portal_authentication

  field :name,            	      type: String
  field :description,             type: String
  field :branch_id,               type: String
  field :host,                    type: String
  field :port,                    type: String
  field :send_property_url, 			type: String
  field :remove_property_url, 		type: String
  field :branch_properties_url,   type: String

  validates_presence_of :name, :description, :host, :port
  validates_uniqueness_of :branch_id

end
