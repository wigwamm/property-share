web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
resque: bundle exec rake resque:work TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE="*"