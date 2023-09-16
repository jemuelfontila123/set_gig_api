class Api::V1::Guest::SchedulesController < ApplicationController
  
  before_action :require_login, if: bearer_token?  
  before_action :set_schedule, only: [:show ]

  def index  
    production_schedules = Schedule.where(schedule_type: Schedule.schedule_types[:production], availability: true)
    band_schedules = Schedule.where(schedule_type: Schedule.schedule_types[:band], availability: true) 
    render json: {production_schedules: production_schedules, band_schedules: band_schedules, status: 200}
  end    
 
  # Needs to test/ Need to add login for user
  def show   
    render json: {schedule: @schedule, minutes_left: @schedule.access_seconds_left} if user_or_guest_can_access
    render json: {error_message: "Cannot access right now. Try another schedule or check it out later", status: 401} 
  end  
 
  private 

  def user_or_guest_can_access? 
    (@user.present? &&  @schedule.can_access?(@user.email_address)) || @schedule.can_access?(nil) || @schedule.can_access(request.headers['Authorization'])
  end

  def set_schedule 
    @schedule = Schedule.find_by(id: params[:id], availability: true) 
    render json: {error_message: "Cannot access", status: 401} if @schedule.nil? 
  end
  
  def bearer_token? 
    token_exists? && request.headers['Authorization'].include? "Bearer"
  end

end