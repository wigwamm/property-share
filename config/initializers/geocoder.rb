Geocoder.configure(

  # geocoding service (see below for supported options):
  lookup: :yandex,
  # IP address geocoding service (see below for supported options):
  ip_lookup: :maxmind,
  # to use an API key:
  # api_key: "...",
  # geocoding service request timeout, in seconds (default 3):
  timeout: 5,
  # set default units to kilometers:
  units: :mi,
  # caching (see below for details):
  cache: $redis,
  cache_prefix: "geocoder_#{Rails.env}"

)