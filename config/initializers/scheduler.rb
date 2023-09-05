#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# recurrent task...
s.every '30d', first_in: Time.now + 5.minutes do

  Rails.logger.info "hello, it's #{Time.now}"
  Rails.logger.flush
end