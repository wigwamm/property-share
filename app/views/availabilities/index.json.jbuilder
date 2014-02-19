json.array!(@availabilities) do |availability|
  json.extract! availability, :id, :available_at, :booked, :duration
  json.url availability_url(availability, format: :json)
end
