class Blmgen
  include Mongoid::Document

  field :property_id, type: String
  field :available_from, type: String
  field :ADDRESS_1, type: String
  field :ADDRESS_2, type: String
  field :TOWN, type: String
  field :POSTCODE1, type: String

  validates :property_id, presence: true, allow_blank: false
  validates :available_from, presence: true, allow_blank: false
  validates :ADDRESS_1, presence: true, allow_blank: false
  validates :ADDRESS_2, presence: true, allow_blank: false
  validates :TOWN, presence: true, allow_blank: false
  validates :POSTCODE1, presence: true, allow_blank: false
end
