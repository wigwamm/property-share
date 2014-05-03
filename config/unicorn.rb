# VERSIONS that _appear_ to work with the bellow configuration
# redis 3.0.3
# resque 1.24.1
# unicorn 4.6.2
 
preload_app true
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 15
preload_app true
 
before_fork do |server, worker|
  # # Replace with MongoDB or whatever
  # if defined?(ActiveRecord::Base)
  #   ActiveRecord::Base.connection.disconnect!
  #   Rails.logger.info('Disconnected from ActiveRecord')
  # end
 
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end
end
 
after_fork do |server, worker|
  # # Replace with MongoDB or whatever
  # if defined?(ActiveRecord::Base)
  #   ActiveRecord::Base.establish_connection
  #   Rails.logger.info('Connected to ActiveRecord')
  # end
 
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end
end