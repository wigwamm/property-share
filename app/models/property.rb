class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  belongs_to :agent
  has_many :visits
  
  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  attr_accessor :description, :images_attributes

  field :title,              type: String
  field :description,        type: String
  field :price,              type: Float
  field :url,                type: String, default: SecureRandom.hex(4)
  field :street,             type: String
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
