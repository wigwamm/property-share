json.array!(@rightmove_media) do |rightmove_medium|
  json.extract! rightmove_medium, :id
  json.url rightmove_medium_url(rightmove_medium, format: :json)
end
