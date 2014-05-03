web: bundle exec rails server thin -p $PORT
scheduler: bundle exec rake resque:scheduler 
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE="*" bundle exec rake environment resque:work 