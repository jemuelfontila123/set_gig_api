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
dates = (start_date..end_date).to_a.select {|date| date.on_weekday?}
dates.each do |date| 
  iteration = 0 
  start_time = DateTime.new(date.year, date.month, date.day, 19)
  while iteration < 12 
    end_time = start_time + 30.minutes
    date = Schedule.find_or_initialize_by(start_time: start_time, end_time: end_time, schedule_type: Schedule.schedule_types[:band])
    start_time = start_time + 30.minutes 
    iteration+=1 
    date.save unless date.persisted?
  end
end

#Create Booking - Production
production_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:production]).limit(5)
production_schedule.each do |schedule|
  contact_information = ContactInformation.find_or_initialize_by(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, mobile_number: '09196022579', email_address: Faker::Internet.email)
  booking = Booking.find_or_initialize_by(schedule: schedule, name: Faker::Music.band, previous_events: Faker::Quote.famous_last_words, description: Faker::Quote.robin, contact_information: contact_information)
  online_link = OnlineLink.find_or_initialize_by(url: "https://www.youtube.com/watch?v=SsL6RVQlIRk", booking: booking)
  if contact_information.new_record? && contact_information.save 
    online_link.save if online_link.new_record? 
    booking.save if booking.new_record? 
  end 

end

#Create Booking - Band Schedule 
band_schedule = Schedule.where(schedule_type: Schedule.schedule_types[:band]).limit(100) 
band_schedule.each do |schedule|
  contact_information = ContactInformation.find_or_initialize_by(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, mobile_number: '09196022579', email_address: Faker::Internet.email)
  booking = Booking.find_or_initialize_by(schedule: schedule, name: Faker::Music.band, description: Faker::Quote.robin, contact_information: contact_information)
  online_link = OnlineLink.find_or_initialize_by(url: "https://www.youtube.com/watch?v=SsL6RVQlIRk", booking: booking)
  tentative_lineup = TentativeLineup.find_or_initialize_by(booking: booking, band_name: Faker::Music.band, genres: [Faker::Music.genre])
  if contact_information.new_record? && contact_information.save 
    online_link.save if online_link.new_record? 
    booking.save if booking.new_record? 
    tentative_lineup.save if tentative_lineup.new_record?
  end 
end
