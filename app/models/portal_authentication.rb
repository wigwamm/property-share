class PortalAuthentication
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :portal

  field :ssl, type: Boolean

  # HTTP Auth
  field :username, type: String
  field :password, type: String

  # SSL
  field :pem,   type: String
  field :pkcs12, type: String
  field :pkcs12_password, type: String

end