web: bundle exec rails server thin -p $PORT
worker: TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE="*" bundle exec rake resque:work