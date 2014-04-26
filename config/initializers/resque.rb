ENV["REDISTOGO_URL"] ||= "redis://redistogo:6f7a4f7d7619a54f34e788e0b610912d@jack.redistogo.com:10167"
ENV["REDISTOGO_URL"] = "redis://127.0.0.1:6379" if (Rails.env.development?) || (Rails.env.test?)

uri = URI.parse(ENV["REDISTOGO_URL"])

Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
Resque.redis.namespace = "resque:propertyshare"
