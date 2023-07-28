class Validators::BookingValidator < ActiveModel::Validator 

  def validate(record) 
    record.errors.add(:previous_events,'previous events is required') if record.previous_events == nil && record.schedule.production?
  end

end