class PortalAuthentication
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :portal

  field :ssl, type: Boolean

  # HTTP Auth
  field :username, type: String
  field :password, type: String

  # SSL
  field :pem,   type: File
  field :pkcs12, type: File
  field :pkcs12_password, type: String

end