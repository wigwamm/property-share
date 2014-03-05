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
  field :view_count,         type: Integer
  field :active,             type: Boolean, default: true

  geocoded_by :address
  after_validation :geocode
  after_create :position_images
  after_update :update_url

  validates :title, presence: true, uniqueness: true
  validates :street, presence: true
  validates :postcode, presence: true
  validates :url, presence: true, uniqueness: true

  def update_url
    if self.title_changed?
      if self.title_was.gsub(/\ /, "_").downcase == self.url
        self.url = self.title.gsub(/\ /, "_").downcase
      end
    end
  end

  def address
    return self.street + ", " + self.postcode
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

end
