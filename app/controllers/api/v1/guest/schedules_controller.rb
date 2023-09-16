class Api::V1::Guest::SchedulesController < ApplicationController
  
  before_action :require_login, if: token_exists? 

  def index  
    production_schedules = Schedule.where(schedule_type: Schedule.schedule_types[:production], availability: true)
    band_schedules = Schedule.where(schedule_type: Schedule.schedule_types[:band], availability: true) 
    render json: {production_schedules: production_schedules, band_schedules: band_schedules, status: 200}
  end    

  def show   
    schedule = Schedule.find(params[:id]) 
    if schedule.can_access?  
      token = @user.email_address if @user.present?
      schedule.grant_access(token || guest_session_token)
      render json: {schedule: schedule, minutes_left: schedule.access_seconds_left}
    else 
      render json: {error_message: "Cannot access right now. Try another schedule or check it out later", status: 401} 
    end 
  end  

  private 

  def guest_session_token
    SecureRandom.uuid
  end

   

end