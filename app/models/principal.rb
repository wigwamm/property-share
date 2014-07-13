class Principal
  include Mongoid::Document

  belongs_to :property
  
  field :principal_email_address, type: String, default: 'team@wigwamm.co.uk'
  # field :auto_email_when_live,    type: Boolean, default: false
  # field :auto_email_updates,      type: Boolean, default: false

  validates_presence_of :principal_email_address
end
