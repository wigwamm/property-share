json.array!(@rightmove_properties) do |rightmove_property|
  json.extract! rightmove_property, :id
  json.url rightmove_property_url(rightmove_property, format: :json)
end
