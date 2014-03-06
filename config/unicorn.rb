# See comment by @paulelliott
worker_processes 3
timeout 30
preload_app true
 
before_fork do |server, worker|
 
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end
end
 
after_fork do |server, worker|
 
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI'] ||= "redis://redistogo:698abf50069280bee73198fcecf18cd4@jack.redistogo.com:9698/"
    Rails.logger.info('Connected to Redis')
  end
end