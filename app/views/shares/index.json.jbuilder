json.array!(@shares) do |share|
  json.extract! share, :id, :to_email, :to_mobile
  json.url share_url(share, format: :json)
end
