
module DateHelper

  def self.generate_production_dates(start_date = DateTime.now, end_date = Date.today.end_of_month) 
    return [] if start_date.after? end_date
    production_dates = [] 
    dates = (start_date .. end_date).to_a.select {|date| date.on_weekend? } 
    dates.each do |date| 
      start_time = DateTime.new(date.year, date.month, date.day, 19)
      end_time = (start_time + 1.day).change(hour: 1)
      production_dates << {start_time: start_time, end_time: end_time}
    end
    production_dates
  end 

  def self.generate_band_dates(start_date = DateTime.now, end_date = Date.today.end_of_month) 
    return [] if start_date.after? end_date
    band_dates = [] 
    dates = (start_date .. end_date).to_a.select {|date| date.on_weekday? } 
    dates.each do |date| 
      start_time = DateTime.new(date.year, date.month, date.day, 19)
      iteration = 0 
      while iteration < 12 
        end_time = start_time + 30.minutes
        band_dates << {start_time: start_time, end_time: end_time}
        start_time = start_time + 30.minutes 
        iteration+=1 
      end 
    end 
    band_dates
  end 

end