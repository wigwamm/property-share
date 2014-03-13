bitly_config = YAML.load(ERB.new(File.read("#{Rails.root}/config/bitly.yml")).result)[Rails.env].symbolize_keys!

Bitly.configure do |config|
  config.api_version = 3
  config.login = bitly_config[:login]
  config.access_token = bitly_config[:access_token]
end

BITLY = Bitly.client