ENV["REDISTOGO_URL"] ||= "redis://redistogo:698abf50069280bee73198fcecf18cd4@jack.redistogo.com:9698/"
ENV["REDISTOGO_URL"] = "redis://127.0.0.1:6379" if (Rails.env.development?) || (Rails.env.test?)
ENV['QUEUE'] = '*'

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
Resque.redis.namespace = "resque:propertyshare"