bitly_config = YAML.load_file('config/bitly.yml').with_indifferent_access[Rails.env]

Bitly.configure do |config|
  config.api_version = 3
  config.login = bitly_config[:login]
  config.access_token = bitly_config[:access_token]
end

BITLY = Bitly.client