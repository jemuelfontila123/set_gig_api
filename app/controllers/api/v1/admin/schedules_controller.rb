class Api::V1::Admin::SchedulesController < Api::V1::Admin::BaseController 

  before_action :set_schedule, only: [:show] 
  before_action :require_login 

  def index  
    production_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:production])
    band_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:band]) 
    render json: {production_schedules: production_schedule, band_schedules: band_schedule, status: 200}
  end 

  def show 
    if @schedule.present? 
      render json: {schedule: @schedule, status: 200}
    else 
      render json: {error: 'schedule not found', status: 404}
    end
  end



  private 

  def schedule_params 
    params.require(:schedule).permit(:id)
  end 

  def set_schedule
    @schedule = Schedule.find(schedule_params[:id])
  end 

end 