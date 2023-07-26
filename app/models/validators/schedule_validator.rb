class Validators::ScheduleValidator 

  def validate(record)
    if record.production? 
        production_schedule_check(record)
    elsif record.band? 
        band_schedule_check(record)
    end 

  end

  def band_schedule_midnight_check(record)
    record.errors.add(:start_time, "the only available start date during saturday (band booking) is 12:00 am and 12:30 am") unless record.start_time.minute == 0 || record.start_time.minute == 30
    record.errors.add(:end_time, "the booking end time should be 30 minutes after the date time") unless 30.minutes.ago(record.end_time) == record.start_time
  end


  def band_schedule_check(record)
    record.errors.add(:start_time, "the only available date is from monday to saturday 1am")  if record.start_time.sunday?
    elsif record.start_time.hour < 19 || (record.start_time.hour >= 19 || record.start_time.hour <= 23 && (record.start_time.minute != 0 || record.start_time.minute != 30))
        record.errors.add(:start_time, "the only available start date from mon-fri is 7pm, 7:30 pm, 8:00pm up until 11:00 pm")
    end 
    record.errors.add(:end_time, "the booking end time should be 30 minutes after the date time") unless 30.minutes.ago(record.end_time) == record.start_time 
  end

  def production_schedule_check(record)
      reocrd.errors.add(:start_time, "only saturday and sunday for production booking") unless record.start_time.saturday? || record.start_time.sunday?
      record.errors.add(:start_time, "the only available start date during (production booking) weekends is 7pm") unless record.start_time.hour == 19 
      record.errors.add(:end_time, "only lasts until 1am and should be the next day of the start date") unless record.end_time.hour == 1
      record.errors.add(:end_time, "the end day should be the next day of the start day") unless record.end_time.mjd - record.start_time == 1 
    end
  end

end