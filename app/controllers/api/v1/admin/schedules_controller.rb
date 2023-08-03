class Api::V1::Admin::SchedulesController < Api::V1::Admin::BaseController 

  before_action :set_schedule, only: [:show, :update] 
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
      render json: {error_message: "An error has occured", status: 404}
    end
  end

  def update
    if @schedule.present? && @schedule.update(schedule_params) 
      render json: {schedule: @schedule, status: 200}
    elsif @schedule.present? && @schedule.errors.present?
      render json: {error_message: @schedule.errors.messages, status: 404} 
    else 
      render json: {error_message: "An error has occured", status: 404}
    end
  end

  def create 
    schedule = Schedule.new(schedule_params) 
    if schedule.save
      render json: {schedule: schedule, status: 200}
    else 
      render json: {error_message: schedule.errors.messages, status: 404 } 
    end
  end

  private 

  def schedule_params 
    params.require(:schedule).permit(:start_time, :end_time, :availability, :schedule_type)
  end 

  def set_schedule
    @schedule = Schedule.find(params[:id]) rescue nil
  end 

end 