# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

job_type :rake,    "cd :path && :environment_variable=:environment bundle exec rake environment :task --silent :output"

every 1.day, :at => '5:00 am' do
  rake "notify:send_emails"
end

every 1.day, :at => '5:05 am' do
  rake "notify:downgrade_plans"
end

every 1.day, :at => '5:10am' do
  rake "reap:remove_deleted_projects"
end

# Learn more: http://github.com/javan/whenever
