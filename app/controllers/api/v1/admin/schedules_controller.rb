class Api::V1::Admin::SchedulesController < Api::V1::Admin::BaseController 

  def index  
    production_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:production])
    band_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:band]) 
    render json: {production_schedule: production_schedule, band_schedule: band_schedule}
  end  

end