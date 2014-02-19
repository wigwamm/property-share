json.array!(@visits) do |visit|
  json.extract! visit, :id, :scheduled_at
  json.url visit_url(visit, format: :json)
end
