# Resque.configure do |config|

#   # Set the redis connection. Takes any of:
#   #   String - a redis url string (e.g., 'redis://host:port')
#   #   String - 'hostname:port[:db][/namespace]'
#   #   Redis - a redis connection that will be namespaced :resque
#   #   Redis::Namespace - a namespaced redis connection that will be used as-is
#   #   Redis::Distributed - a distributed redis connection that will be used as-is
#   #   Hash - a redis connection hash (e.g. {:host => 'localhost', :port => 6379, :db => 0})
#   ENV["REDISTOGO_URL"] ||= "redis://redistogo:32ba5ef743a96a004a26da0411d0652b@albacore.redistogo.com:10164/"

#   uri = URI.parse(ENV["REDISTOGO_URL"])
#   config.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
#   config.redis.namespace = "resque:propertyshare"
# end

ENV["REDISTOGO_URL"] ||= "redis://redistogo:698abf50069280bee73198fcecf18cd4@jack.redistogo.com:9698/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
Resque.redis.namespace = "resque:propertyshare"
