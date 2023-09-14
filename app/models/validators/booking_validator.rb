class Validators::BookingValidator < ActiveModel::Validator 

  def validate(record) 
    record.errors.add(:previous_events,'previous events is required') if record.previous_events == nil && record.schedule.present? && record.schedule.production?
    record.errors.add(:schedule, "schedule is already closed") if record.schedule.present? && record.schedule.availability == false 
  end
  
  def password_rules(record)
    record.errors.add :password, ' must contain at least 1 uppercase ' unless record.password.match(/\p{Upper}/)
    record.errors.add :password, ' must contain at least 1 lowercase' unless record.password.match(/\p{Lower}/)
    record.errors.add :password, ' must contain at least 1 number' unless record.password.count("0-9") > 0

    special = "?<>',?[]}{=-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    record.errors.add :password, ' must contain special character' unless record.password.match(regex)
    
  end

end