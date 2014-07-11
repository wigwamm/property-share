json.extract! @property, :id, :title, :created_at, :updated_at
json.description @property.detail.description
json.price @property.price_information.price
json.url @property.id.to_s
