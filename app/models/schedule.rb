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
      sched = Schedule.find_or_initialize_by(start_time: date[:start_time], end_time: date[:end_time],  schedule_type: Schedule.schedule_types[:production]) 
      schedules << sched unless sched.persisted? 
    end 
    schedules
  end
    


end