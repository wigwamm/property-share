class Room
  include Mongoid::Document

  belongs_to :detail
  
  field :room_name,               type: String
  field :room_description,        type: String
  field :room_length,             type: Float
  field :room_width,              type: Float
  field :room_dimension_unit,     type: Integer
  field :room_photo_urls,         type: Array

  DIMENSION_UNITS = %w(metres centimetres millimetres feet inches)

  validates_presence_of :room_name
end
