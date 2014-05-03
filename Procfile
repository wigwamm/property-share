web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
scheduler: bundle exec rake resque:scheduler 
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 VVERBOSE=1 QUEUE=* rake environment resque:work
