class RightmoveProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :property

  # Network Group
  field :network_id, type: Integer

  # Branch Group
  field :branch_id, type: Integer
  field :channel_id, type: Integer
  field :overseas, type: Boolean, default: nil

  # Property Group
  field :agent_ref, type: String
  field :published, type: Boolean
  field :property_type:, type: Integer
  field :status, type: Integer
  field :new_home, type: Boolean, default: nil, default: nil
  field :student_property, type: Boolean, default: nil
  field :create_date, type: String, default: nil # Timestamp
  field :update_date, type: String, default: nil # Timestamp
  field :date_available, type: String, default: nil
  field :contract_months, type: Integer, default: nil
  field :minimum_term, type: Integer, default: nil
  field :let_type, type: Integer, default: nil

  # Address Group
  field :house_name_number, type: String
  field :address_2, type: String, default: nil
  field :address_3, type: String, default: nil
  field :address_4, type: String, default: nil
  field :town, type: String
  field :postcode_1, type: String
  field :postcode_2, type: String
  field :display_address, type: String
  field :latitude, type: Double, default: nil
  field :longitude, type: Double, default: nil
  field :pov_latitiude, type: Double, default: nil
  field :pov_longitude, type: Double, default: nil
  field :pov_pitch, type: Double, default: nil
  field :pov_heading, type: Double, default: nil
  field :pov_zoom, type: Integer, default: nil

  # Price Group
  field :price, type: Double
  field :price_qualifier, type: Integer, default: nil
  field :deposit, type: Integer, default: nil
  field :administration_fee, type: String, default: nil
  field :rent_frequency, type: Integer, default: nil
  field :tenure_type, type: Integer, default: nil
  field :auction, type: Boolean, default: nil
  field :tenure_unexpired_years, type: Integer, default: nil
  field :price_per_unit_area, type: Double, default: nil

  # Details Group
  field :summary, type: String
  field :description, type: String
  field :features, type: Array, default: nil
  field :bedrooms, type: Integer
  field :bathrooms, type: Integer, default: nil
  field :reception_rooms, type: Integer, default: nil
  field :parking, type: Array, default: nil
  field :outside_space, type: Array, default: nil
  field :year_built, type: Integer, default: nil
  field :internal_area, type: Double, default: nil
  field :internal_area_unit, type: Integer, default: nil
  field :land_area, type: Double, default: nil
  field :land_area_unit, type: Integer, default: nil
  field :floors, type: Integer, default: nil
  field :entrance_floor, type: Integer, default: nil
  field :condition, type: Integer, default: nil
  field :accessibility, type: Array, default: nil
  field :heating, type: Array, default: nil
  field :furnished_type, type: Integer, default: nil
  field :pets_allowed, type: Boolean, default: nil
  field :smokers_considered, type: Boolean, default: nil
  field :housing_benefit_considered, type: Boolean, default: nil
  field :sharers_considered, type: Boolean, default: nil
  field :burglar_alarm, type: Boolean, default: nil
  field :washing_machine, type: Boolean, default: nil
  field :dishwasher, type: Boolean, default: nil
  field :water_bill_inc, type: Boolean, default: nil
  field :electricity_bill_inc, type: Boolean, default: nil
  field :tv_licence_inc, type: Boolean, default: nil
  field :sat_cable_tv_bill_inc, type: Boolean, default: nil
  field :internet_bill_inc, type: Boolean, default: nil
  field :business_for_sale, type: Boolean, default: nil
  field :comm_use_class, type: Array, default: nil

  # Room Group - not required
  field :room_name, type: String
  field :room_description, type: String, default: nil
  field :room_length, type: Double, default: nil
  field :room_width, type: Double, default: nil
  field :room_dimension_unit, type: Integer, default: nil
  field :room_photo_urls, type: Array, default: nil

  # Media Group - not required
  field :media_type, type: Integer
  field :media_url, type: String
  field :caption, type: String, default: nil
  field :sort_order, type: Integer, default: nil
  field :media_update_date, type: String, default: nil

  # Principal Group - not required
  field :principal_email_address, type: String
  field :auto_email_when_live, type: Boolean, default: nil
  field :auto_email_updates, type: Boolean, default: nil


  # Required fields
  validates :network_id,      :presence => true

  validates :branch_id,      :presence => true
  validates :channel_id,      :presence => true
  
  validates :agent_ref,        :presence => true
  validates :published,      :presence => true
  validates :property_type,   :presence => true
  validates :status,          :presence => true

  validates :house_name_number,        :presence => true
  validates :town,      :presence => true
  validates :postcode_1,   :presence => true
  validates :postcode_2,          :presence => true
  validates :display_address,          :presence => true

  validates :price,     :presence => true

end, default: nil, default: nil