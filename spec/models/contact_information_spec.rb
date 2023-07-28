require 'rails_helper'

RSpec.describe ContactInformation, type: :model do 

  
  let(:band_schedule) {
    Schedule.new(start_time: DateTime.new(2023,7,24,19), end_time: DateTime.new(2023,7,24,19,30), schedule_type: Schedule.schedule_types[:band])
  }

  let(:booking) {
    Booking.new(name: "booking", description: "type of booking", previous_events: "at intramuros", schedule: band_schedule )
  }

  subject {
    described_class.new(first_name: 'Jemuel', last_name: 'Fontila', mobile_number: '09126022573', email_address: 'jemuel123@gmail.com')
  }


end