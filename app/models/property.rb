class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  belongs_to :agency
  belongs_to :agent
  has_many :visits
  
  attr_accessor :images_attributes

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  field :title,              type: String
  field :description,        type: String
  field :price,              type: String
  field :url,                type: String
  field :tiny_url,           type: String
  field :street,             type: String
  field :postcode,           type: String
  field :coordinates,        type: Array
  field :view_count,         type: Integer, default: 0
  field :active,             type: Boolean, default: true

  geocoded_by       :address

  after_validation  :geocode
  before_create     :create_unique_url
  after_create      :position_images
  before_validation :set_agency

  validates :title, presence: true
  validates :street, presence: true
  validates :postcode, presence: true

  validates :agency_id, presence: true
  validates :agent_id, presence: true
  validates :url, presence: true, uniqueness: true

  def address
    begin
      return self.street + ", " + self.postcode if self.street && self.postcode
    end
  end

  def to_param
    url
  end

  protected

  def position_images
    self.images.each_with_index do |img, i| 
      img.update_attribute(:position, i)
      img.update_attribute(:main_image, true) if i == 0
    end
  end

  def set_agency
    begin
      self.agency_id = self.agent.agency.id if self.agent
    end
  end

  def create_unique_url
    begin
      self. url = SecureRandom.hex(3) # or whatever you chose like UUID tools
    end while self.class.where(:url => url).exists?
  end


end
