class Schedule < ApplicationRecord 
  
    validates :start_time, presence: true
    validates :end_time, presence: true 
    
    enum schedule_type: { production: 0, band: 1}
end