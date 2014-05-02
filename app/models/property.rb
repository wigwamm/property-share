class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token
  include Geocoder::Model::Mongoid

  # belongs_to :agency
  belongs_to :agent
  has_many :visits

  embeds_many :images, cascade_callbacks: true
  accepts_nested_attributes_for :images, allow_destroy: true
  attr_accessor :images_attributes

  field :title, type: String
  field :description, type: String
  field :property_type, type: String
  field :price, type: Integer
  field :price_unit, type: String

  field :street, type: String
  field :postcode, type: String
  field :country, type: String, default: "UK"
  field :coordinates, type: Array, default: []

  field :active, type: Mongoid::Boolean, default: false
  field :assets_uuid, type: String, default: SecureRandom.uuid

  field :view_count, type: Integer, default: 0
  field :photo_count, type: Integer, default: 0

  field :url, type: String
  field :tiny_url, type: String

  token field_name: :url
  geocoded_by :address

  after_save :background_tasks

  # Validations

  validates :title, presence: true,  allow_blank: false, 
    length: {
      minimum: 6,
      maximum: 100,
      too_short: "your title is too short, min %{count} characters",
      too_long: "your title is too long, max %{count} characters"
    }

  validates :price, presence: true, allow_blank: false, 
    length: {
      minimum: 2,
      too_short: "that seems a little cheap"
    }

  validates :price_unit, presence: true, allow_blank: false

  validates :street, presence: true, allow_blank: false
  validates :postcode, presence: true, allow_blank: false, format: { 
      with: /[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2}/i,
      message: "not a valid UK postcode"
    }

  # actions

  def activate!
    return self.update_attribute(:active,true)
  end

  def address
    begin
      return self.street + ", " + self.postcode + ", " + self.country if self.street && self.postcode
    end
  end

  def find_lat_long
    begin
      attributes = {property_id: self.id.to_s, action: "find_lat_long"}
      Resque.enqueue(PropertyTasks, "actions", attributes) unless self.geocode
    end
  end

  protected

  def background_tasks
    ###################################################
    ### =>  Defer this action to the controlller
    ###################################################
    # return true if Rails.env == "test"
    begin
      if (self.street_changed?) || (self.postcode_changed?)
        attributes = {property_id: self.id.to_s, action: "find_lat_long"}
        Resque.enqueue(PropertyTasks, "actions", attributes)
      end
    end
  end

end
