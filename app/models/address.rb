class Address
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  belongs_to :property
  
  field :house_name_number,       type: String
  field :address_2,               type: String
  field :address_3,               type: String
  field :address_4,               type: String
  field :town,                    type: String
  field :postcode,                type: String
  field :postcode_1,              type: String
  field :postcode_2,              type: String
  field :display_address,         type: String
  field :coordinates,             type: Array
  # field :pov_latitude,            type: String
  # field :pov_longitude,           type: String
  # field :pov_pitch,               type: String
  # field :pov_heading,             type: String
  # field :pov_zoom,                type: String

  geocoded_by :full_address
  before_validation :geocode, :regenerate

  validates_presence_of :house_name_number, :town, :postcode

  def full_address
    [house_name_number, address_2, address_3, address_4, postcode_1, postcode_2].join(', ')
  end

  def latitude
    coordinates[1] rescue nil
  end

  def longitude
    coordinates[0] rescue nil
  end

  def regenerate
    (1..2).each { |i| self.send "postcode_#{i}=", (postcode.strip.split(' ')[i - 1] rescue nil) }
  end
end
