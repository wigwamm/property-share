ENV["REDISTOGO_URL"] ||= "redis://redistogo:6f7a4f7d7619a54f34e788e0b610912d@jack.redistogo.com:10167"
ENV["REDISTOGO_URL"] = "redis://127.0.0.1:6379" if (Rails.env.development?) || (Rails.env.test?)
uri = URI.parse(ENV["REDISTOGO_URL"])

Geocoder.configure(

  # geocoding service (see below for supported options):
  lookup: :google,
  # IP address geocoding service (see below for supported options):
  # ip_lookup: :maxmind,
  # to use an API key:
  # api_key: "...",
  # geocoding service request timeout, in seconds (default 3):
  timeout: 5,
  units: :mi,
  cache: Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true),
  cache_prefix: "geocoder:propertyshare:"

)