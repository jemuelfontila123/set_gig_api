require 'rails_helper'

RSpec.describe Booking, type: :model do 
    
  let(:production_schedule) { 
    Schedule.new(start_time: DateTime.new(2023,7,23,19), end_time: DateTime.new(2023,7,24,1), schedule_type: Schedule.schedule_types[:production])
  } 

  let(:band_schedule) {
    Schedule.new(start_time: DateTime.new(2023,7,24,19), end_time: DateTime.new(2023,7,24,19,30), schedule_type: Schedule.schedule_types[:band])
  }

  subject {
    Booking.new(name: "booking", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule )
  }


  describe 'booking without schedule' do 

    it "will fail" do 
      subject.schedule = nil
      expect(subject).to_not be_valid
    end

  end

  describe 'booking with schedule' do 
   
    context 'has a production schedule' do 
      it "will be valid with other attributes valid" do 
        expect(subject).to be_valid
      end

      it "will not be valid without production name" do 
        subject.name = nil 
        expect(subject).to_not be_valid
      end

      it "will not be valid without production description" do 
        subject.description = nil 
        expect(subject).to_not be_valid
      end

      it "will not be valid without previous_events" do  
        subject.previous_events = nil 
        expect(subject).to_not be_valid
      end
    end

    context 'has a band schedule' do 
      it "will be valid with other attributes valid" do 
        subject.schedule = band_schedule
        expect(subject).to be_valid
      end

      it "will not be valid without band name" do 
        subject.schedule = band_schedule
        subject.name = nil 
        expect(subject).to_not be_valid
      end

      it "will not be valid without band description" do 
        subject.schedule = band_schedule
        subject.description = nil 
        expect(subject).to_not be_valid 
      end
    end
  end 

  describe '#temporarily_close_schedule' do 

  context 'when status is not approved' do 
    it "will close the schedule availability" do 
      expect {Booking.create!(name: "booking_1", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "denied")
             }.to change{production_schedule.availability}.from(true). to(false)
    end
  end

  context 'when status is approved' do 
    it "will not change the schedule availability" do 
      expect {Booking.create!(name: "booking_1", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "approved")
              }.not_to change{production_schedule.availability}
    end
  end

  end

  describe '#update_related_bookings' do 
    before(:each) do 
      allow_any_instance_of(Booking).to receive_messages(:temporarily_close_schedule => nil)
      @booking_1 = Booking.create!(name: "booking_1", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "denied")
      @booking_2 = Booking.create!(name: "booking_2", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "pending" )
    end
    
    context 'when booking status is updated' do  
      it "will change the status of other booking related to the schedule to denied if the status is approved" do  
        expect {@booking_1.update(status: Booking.statuses[:approved])}.to change{@booking_2.reload.status}.from("pending"). to("denied")
      end
      it "will not change the status of other booking related to the schedule to denied if the status is not approved" do  
        expect {@booking_1.update(status: Booking.statuses[:denied])}.not_to change{@booking_2.reload.status}
      end
    end
  end

end