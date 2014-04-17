json.array!(@availabilities) do |availability|
  json.extract! availability, :id, :available_at, :booked, :duration, :from
  json.url availability_url(availability, format: :json)
end
