class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  belongs_to :agent
  has_many :visits
  
  attr_accessor :images_attributes

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  field :title,              type: String
  field :description,        type: String
  field :price,              type: String
  field :url,                type: String
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

  def to_param
    url
  end

end
