class OpenScheduleJob < ApplicationJob
  queue_as :default

  # Add Loggers
  def perform(schedule) 
    begin 
      schedule.update(availability: true) 
    rescue StandardError => e 
      p "Error"
    end
  end
end
