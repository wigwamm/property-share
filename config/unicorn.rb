preload_app true
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 30
preload_app true

before_fork do |server, worker| # Disconnect since the database connection will not carry over 

  if defined? ActiveRecord::Base 
    ActiveRecord::Base.connection.disconnect! 
  end 
  if defined?(Resque) 
    Resque.redis.quit 
    Rails.logger.info('Disconnected from Redis') 
  end 
end 

after_fork do |server, worker| # Start up the database connection again in the worker

  if defined?(ActiveRecord::Base) 
    ActiveRecord::Base.establish_connection 
  end 
  if defined?(Resque) 
    Resque.redis = ENV['REDISTOGO_URL'] ||= "redis://redistogo:698abf50069280bee73198fcecf18cd4@jack.redistogo.com:9698/"
    Rails.logger.info('Connected to Redis') 
  end 
end