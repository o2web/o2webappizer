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

# Learn more: http://github.com/javan/whenever

set :output, "#{Whenever.path}/log/cron.log"
env :RAILS_ENV, @environment
env :RAILS_ROOT, Whenever.path
env :PATH, ENV['PATH']
backup = "~/.rbenv/shims/backup perform -t db_backup --config_file #{Whenever.path}/config/Backup/config.rb"

case @environment
when 'development'
  # every 1.minute do
  #   rake 'stuff:to:do'
  # end
when 'vagrant'
  every 1.minute do
    # command backup
  end
when 'staging'
  every 1.day, :at => "12:00am" do
    command backup
  end
when 'production'
  every 1.day, :at => "12:00am" do
    command backup
  end
else
  raise 'RAILS_ENV undefined'
end
