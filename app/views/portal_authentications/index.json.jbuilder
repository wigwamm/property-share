json.array!(@portal_authentications) do |portal_authentication|
  json.extract! portal_authentication, :id
  json.url portal_authentication_url(portal_authentication, format: :json)
end
