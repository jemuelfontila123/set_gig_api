class Schedule < ApplicationRecord 

  include ActiveModel::Validations
  validates_with Validators::ScheduleValidator
  validates :start_time, presence: true
  validates :end_time, presence: true 
    
  enum schedule_type: { production: 0, band: 1}
end