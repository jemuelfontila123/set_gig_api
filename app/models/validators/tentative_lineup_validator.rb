class Validators::TentativeLineupValidator < ActiveModel::Validator 
  def validate(record) 
    record.errors.add(:booking, 'booking type must be band') if (record.booking.present? && record.booking.schedule.production?) || record.booking.nil?
  end
end
