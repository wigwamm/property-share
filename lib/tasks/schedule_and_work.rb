desc "schedule and work, so we only need 1 dyno"

task :schedule_and_work do
  if Process.fork
    sh "rake environment JOBS_PER_FORK=10 TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE="*" resque:work "
  else
    sh "rake JOBS_PER_FORK=1 resque:scheduler"
    Process.wait
  end
end