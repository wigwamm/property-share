class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  field :title, type: String
  field :price, type: Integer
  belongs_to :agent
  has_many :visits

  field :title,              type: String
  field :url,                type: String, default: SecureRandom.hex(4)
  field :description,        type: String
  field :price,              type: Float
  field :street,            type: String
  field :postcode,           type: String
  field :coordinates,        type: Array
  field :view_count,         type: Integer, default: 0
  field :active,             type: Boolean, default: false

  geocoded_by :address
  after_validation :geocode

  validates :title, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true

  def address
    return self.street + ", " + self.postcode
  end

end