class Schedule < ApplicationRecord 

  has_many :bookings, dependent: :destroy 
  
  include ActiveModel::Validations
  validates_with Validators::ScheduleValidator
  validates :start_time, presence: true, uniqueness: true
  validates :end_time, presence: true, uniqueness: true
    
  enum schedule_type: { production: 0, band: 1} 

end