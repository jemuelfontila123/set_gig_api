class Validators::ScheduleValidator < ActiveModel::Validator
  require "active_support/all"

  def validate(record) 
    if record.production? && schedule_exists?(record)
      production_schedule_check(record)
    elsif record.band? && schedule_exists?(record)
      band_schedule_check(record)
    end 

  end

  def band_schedule_check(record)
    record.errors.add(:start_time, "the only available start date from mon-friday is 7pm, 7:30 pm, 8:00pm up until 11:00 pm and 12:00, 12:30 am of saturday")  unless band_allowed_datetime?(record.start_time)
    record.errors.add(:end_time, "the booking end time should be 30 minutes after the date time") unless 30.minutes.ago(record.end_time) == record.start_time 
  end

  def production_schedule_check(record)
    record.errors.add(:start_time, "only saturday and sunday for production booking") unless record.start_time.on_weekend?
    record.errors.add(:start_time, "the only available start date during (production booking) weekends is 7pm") unless record.start_time.hour == 19 
    record.errors.add(:end_time, "the end day should be the next day of the start day and must always only be 1am") unless 6.hours.ago(record.end_time) == record.start_time
  end


  private 

  def schedule_exists?(record)
    record.start_time.present? && record.end_time.present? 
  end

  def band_allowed_datetime?(start_time)
    band_allowed_day?(start_time) &&  band_allowed_hour?(start_time) &&  band_allowed_minute?(start_time) && start_time.strftime('%S').to_i == 0
  end 

  def band_allowed_day?(start_time) 
    start_time.on_weekday? || start_time.saturday? 
  end 

  def band_allowed_hour?(start_time)
    start_time.hour >= 19 || start_time.hour <= 23
  end

  def band_allowed_minute?(start_time)
    start_time.strftime('%M').to_i == 0 || start_time.strftime('%M').to_i == 30
  end

end