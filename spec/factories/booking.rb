FactoryBot.define do 
  factory :booking do 
    sequence(:id) { |n| n}
    name {"band booking"}
    description {"etc booking"}
    previous_events {"dati rati"}
    schedule nil  
    after(:create) do |booking|
      create(:contact_information, booking_id: booking.id)
      create(:online_link, booking_id: booking.id)
    end
  end
end