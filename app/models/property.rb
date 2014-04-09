class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  belongs_to :agent
  has_many :visits
  
  attr_accessor :images_attributes

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  field :title,                   type: String
  field :description,             type: String
  field :price,                   type: String
  field :url,                     type: String
  field :street,                  type: String
  field :postcode,                type: String
  field :coordinates,             type: Array
  field :view_count,              type: Integer
  field :active,                  type: Boolean, default: true
   
  field :bedrooms,                type: Integer
  field :saleorlet,               type: Integer, default: 2 # 1 Sale / 2 Letting
  field :ref,                     type: String
  field :property_type,           type: Integer, default: 0 # RM types - 0 Not Specified, 1 Terraced House, 2 End of terrace house, 3 Semi-detached house, 4 Detached house, 5 Mews house, 6 Cluster house, 7 Ground floor flat, 8 Flat, 9 Studio flat, 10 Ground floor maisonette, 11 Maisonette, 12 Bungalow, 13 Terraced bungalow, 14 Semi-detached bungalow, 15 Detached bungalow, 16 Mobile home, 20 Land, 21 Link detached house, 22 Town house, 23 Cottage, 24 Chalet, 27 Villa, 28 Apartment, 29 Penthouse, 30 Finca, 43 Barn Conversion, 44 Serviced apartment, 45 Parking, 46 Sheltered Housing, 47 Reteirment property, 48 House share, 49 Flat share, 50 Park home, 51 Garages, 52 Farm House, 53 Equestrian facility, 56 Duplex, 59 Triplex, 62 Longere, 65 Gite, 68 Barn, 71 Trulli, 74 Mill, 77 Ruins, 80 Restaurant, 83 Cafe, 86 Mill, 92 Castle, 95 Village House, 101 Cave House, 104 Cortijo, 107 Farm Land, 110 Plot, 113 Country House, 116 Stone House, 117 Caravan, 118 Lodge, 119 Log Cabin, 120 Manor House, 121 Stately Home, 125 Off-Plan, 128 Semi-detached Villa, 131 Detached Villa, 134 Bar/Nightclub, 137 Shop, 140 Riad, 141 House Boat, 142 Hotel Room, 143 Block of Apartments, 144 Private Halls, 178 Office, 181 Business Park, 184 Serviced Office, 187 Retail Property (High Street), 190 Retail Property (Out of Town), 193 Convenience Store, 196 Garages, 199 Hairdresser/Barber Shop, 202 Hotel Room, 205 Petrol Station, 208 Post Office, 211 Pub, 214 Workshop & Retail Space, 217 Distribution Warehouse, 220 Factory, 223 Heavy Industrial, 226 Industrial Park, 229 Light Industrial, 232 Storage, 235 Showroom, 238 Warehouse, 241 Land, 244 Commercial Development, 247 Industrial Development, 250 Residential Development, 253 Commercial Property, 256 Data Centre, 259 Farm, 262 Healthcare Facility, 265 Marine Property, 268 Mixed Use, 271 Research & Development Facility, 274 Science Park, 277 Guest House, 280 Hospitality, 283 Leisure Facility
  field :status,                  type: Integer, default: 1 # RM status - 1 Available, 2 SSTC, 3 SSTCM, 4 Under Offer, 5 Reserved, 6 Let Agreed
  field :date_available,          type: String # Must be set to the format below "dd-MM-yyyy"
  field :published,               type: Boolean, default: true
  field :tenure_type,             type: Integer # 1 Freehold, 2 Leasehold, 3 Feudal, 4 Commonhold, 5 Share of Freehold"
  field :tenure_unexpired_years,  type: Integer

  geocoded_by :address
  after_validation :geocode
  after_create :position_images
  after_update :update_url

  validates_presence_of :street, :postcode, :url, :title, :bedrooms, :saleorlet, :ref, :property_type, :status, :published, :tenure_type, :tenure_unexpired_years
  validates_uniqueness_of :url, :title, :ref

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
