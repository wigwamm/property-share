class PriceInformation
  include Mongoid::Document

  belongs_to :property
  
  field :price,                   type: Float
  field :tenure_type,             type: Integer, default: 1
  field :tenure_unexpired_years,  type: Integer, default: 1
  field :price_qualifier,         type: String
  field :rent_frequency,          type: Integer, default: 1
  field :deposit,                 type: Float, default: 0
  # field :administration_fee,      type: Float
  # field :auction,                 type: Boolean,   default: false
  # field :price_per_unit_area,     type: Float

  TENURE_TYPE = ['Freehold', 'Leasehold', 'Feudal', 'Commonhold', 'Share of Freehold']
  RENT_FREQUENCY = ['Weekly', 'Monthly', 'Quarterly', 'Annual', 'Per person per week']
  PRICE_QUALIFIER = ['Default', 'POA', 'Guide Price', 'Fixed Price', 'Offers in Excess of', 'OIRO', 'Sale by Tender', 'From', 'Shared Ownership', 'Offers Over', 'Part Buy Part Rent', 'Shared Equity']

  validates_presence_of :price
end
