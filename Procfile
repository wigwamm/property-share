web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec rake TERM_CHILD=1 QUEUE=* resque:work
scheduler: bundle exec rake resque:scheduler
