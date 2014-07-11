class Detail
  include Mongoid::Document

  belongs_to :property
  has_many :rooms, dependent: :destroy

  accepts_nested_attributes_for :rooms, reject_if: :all_blank, allow_destroy: true

  field :summary,                 type: String
  field :description,             type: String
  field :bedrooms,                type: Integer, default: 1
  field :furnished_type,          type: Integer, default: 1
  field :features,                type: Array
  # field :bathrooms,               type: Integer
  # field :reception_rooms,         type: Integer
  # field :parking,                 type: Array
  # field :outside_space,           type: Array
  # field :year_built,              type: Integer
  # field :internal_area,           type: Integer
  # field :internal_area_unit,      type: Integer
  # field :land_area,               type: Integer
  # field :floors,                  type: Integer
  # field :entrance_floor,          type: Integer
  # field :condition,               type: Integer
  # field :accessibility,           type: Array
  # field :heating,                 type: Array
  # field :pets_allowed,            type: Boolean
  # field :smokers_considered,      type: Boolean
  # field :housing_benefit_considered,  type: Boolean
  # field :sharers_considered,      type: Boolean
  # field :burglar_alarm,           type: Boolean
  # field :washing_machine,         type: Boolean
  # field :dishwasher,              type: Boolean
  # field :all_bills_inc,           type: Boolean
  # field :water_bill_inc,          type: Boolean
  # field :gas_bill_inc,            type: Boolean
  # field :electricity_bill_inc,    type: Boolean
  # field :tv_licence_inc,          type: Boolean
  # field :sat_cable_tv_bill_inc,   type: Boolean
  # field :internet_bill_inc,       type: Boolean
  # field :business_for_sale,       type: Boolean
  # field :comm_use_class,          type: Array

  FURNISHED_TYPE = ['Furnished', 'Part Furnished', 'Unfurnished']

  validates_presence_of :summary, :description, :bedrooms

end
