require 'faker'

#Seed DB with 1 admin user
admin = Admin.find_or_initialize_by(username: "superadmin")
unless admin.persisted? 
  admin.password = "Minimumisten1#"
  admin.save 
end


#Create A month of Production Schedule  
start_date = Date.today 
end_date = Date.today.end_of_month + 1.month 
dates = (start_date .. end_date).to_a.select {|date| date.on_weekend? } 
dates.each do |date| 
  start_time = DateTime.new(date.year, date.month, date.day, 19)
  end_time = (start_time + 1.day).change(hour: 1)
  date = Schedule.find_or_initialize_by(start_time: start_time, end_time: end_time,  schedule_type: Schedule.schedule_types[:production])
  date.save unless date.persisted?
end

#Create a month of band schedule
# dates = (start_date..end_date).to_a.select {|date| date.on_weekday?}
# dates.each do |date| 

#Create Booking - Band/Production

#Create Online Link 


#Create Tentative Lineup

#Create Contact Information


