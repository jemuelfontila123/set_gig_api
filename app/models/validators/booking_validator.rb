class Validators::BookingValidator < ActiveModel::Validator 

  def validate(record) 
    record.errors.add(:previous_events,'previous events is required') if record.previous_events == nil && record.schedule.present? && record.schedule.production?
    record.errors.add(:schedule, "schedule is already closed") if record.schedule.present? && record.schedule.availability == false
  end

end