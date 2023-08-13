class Api::V1::Guest::SchedulesController < ApplicationController

  def index  
    production_schedules = Schedule.where(schedule_type: Schedule.schedule_types[:production], availability: true)
    band_schedules = Schedule.where(schedule_type: Schedule.schedule_types[:band], availability: true) 
    render json: {production_schedules: production_schedules, band_schedules: band_schedules, status: 200}
  end   

end