class Schedule < ApplicationRecord 
  
  has_many :bookings, dependent: :destroy 
  
  include ActiveModel::Validations
  validates_with Validators::ScheduleValidator
  validates :start_time, presence: true, uniqueness: true
  validates :end_time, presence: true, uniqueness: true
    
  enum schedule_type: { production: 0, band: 1}     

  def self.bulk_create(start_date: DateTime.now, end_date: Date.today.end_of_month, schedule_type: Schedule.schedule_types[:production])
    dates = [] 
    schedules = [] 
    case schedule_type
    when 0 
      dates = DateHelper.generate_production_dates(start_date, end_date) 
    when 1 
      dates = DateHelper.generate_band_dates(start_date, end_date) 
    end 
    dates.each do |date|
      sched = Schedule.find_or_initialize_by(start_time: date[:start_time]) 
      schedules << {start_time: date[:start_time], end_time: date[:end_time], schedule_type: schedule_type} unless sched.persisted? 
    end  
    begin 
      Schedule.insert_all(schedules)
    rescue StandardError => e 
      return e.message 
    end 
    schedules
  end

  def guest_session_token
    SecureRandom.uuid
  end

  def can_access?(token) 
    if locked_token.nil? && locked_at.nil? 
      grant_access(token) 
      return true  
    elsif token == locked_token && access_seconds_left > 0 
      return true 
    end 
    false
  end 

  def access_seconds_left 
    ((locked_at - DateTime.now) * (24 * 60 * 60)).to_i if locked_at.present? 
  end

  def grant_access(token)  
    token = guest_session_token if token.nil?
    update(locked_token: token, locked_at: DateTime.now + 30.minutes) 
  end 

  def release_access 
    update(locked_token: nil, locked_at: nil)  if access_seconds_left < 1
  end 

    


end