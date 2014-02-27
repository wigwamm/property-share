ENV["REDISTOGO_URL"] ||= "redis://redistogo:32ba5ef743a96a004a26da0411d0652b@albacore.redistogo.com:10164/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)