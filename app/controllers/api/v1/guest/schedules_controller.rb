class Api::V1::Guest::SchedulesController < ApplicationController

  def index  
    production_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:production], availability: true)
    band_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:band], availability: true) 
    render json: {production_schedules: production_schedule, band_schedules: band_schedule, status: 200}
  end   

end