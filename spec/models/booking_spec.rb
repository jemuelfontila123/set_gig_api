require 'rails_helper'

RSpec.describe Booking, type: :model do 
     
  let(:production_schedule) { 
    Schedule.new(start_time: DateTime.new(2023,7,23,19), end_time: DateTime.new(2023,7,24,1), schedule_type: Schedule.schedule_types[:production])
  } 

  let(:band_schedule) {
    Schedule.new(start_time: DateTime.new(2023,7,24,19), end_time: DateTime.new(2023,7,24,19,30), schedule_type: Schedule.schedule_types[:band])
  }

  let(:user){
    ContactInformation.new(first_name: 'Jemuel', last_name: 'Fontila', mobile_number: '09126022573', email_address: 'jemuel123@gmail.com')
  } 

  subject {
    Booking.new(name: "booking", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, contact_information: user)
  }


  describe 'booking without schedule' do 

    it "will fail" do 
      subject.schedule = nil
      expect(subject).to_not be_valid
    end

  end 

  describe 'booking without contact_information' do 

    it "will fail" do 
      subject.contact_information = nil 
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
  
  describe '#guest_create_booking' do 
    let(:contact_information) {
      {first_name: "jim", last_name: "tests", email_address: "tests123@gmail.com", mobile_number: "09196022579"}
    }
    let(:online_link) { 
      {url: "facebook.com"}
    }
    context 'when the booking is a production' do 
      let(:schedule_open) { 
        create(:schedule, :production_open)
      }
      let(:schedule_closed) {
        create(:schedule, :production)
      }
      let(:booking) {
        {name: "bobook", schedule_id: schedule_open.id, previous_events: "test", description: "test"}
      }

      it "will create a booking if schedule is valid, contact_information is valid, and online_link is valid" do 
        expect {Booking.guest_create_booking({booking: booking, contact_information: contact_information, online_link: online_link})     
               }.to change{Booking.count}.from(0).to (1)
      end 

      it "will not create a booking if schedule is invalid" do  
        booking[:schedule_id] = schedule_closed.id
        expect {Booking.guest_create_booking({booking: booking, contact_information: contact_information, online_link: online_link})     
               }.not_to change{Booking.count}
      end
      it "will not create a booking if contact_information is missing" do  
        expect {Booking.guest_create_booking({booking: booking, contact_information: nil, online_link: online_link})     
               }.not_to change{Booking.count}
      end
      it "will not create a booking if there is no online link" do  
        expect {Booking.guest_create_booking({booking: booking, contact_information: contact_information})     
               }.not_to change{Booking.count}
      end
    end
    context 'when the booking is a band' do 
      let(:schedule_open) { 
        create(:schedule, :band_open)
      }
      let(:schedule_closed) {
        create(:schedule, :band)
      }
      let(:booking) {
        {name: "bobook", schedule_id: schedule_open.id, previous_events: "test", description: "test"}
      }
      let(:tentative_lineup){
        {band_name: 'Gloc 9', genres: ['Pop', 'Rock'] }
      }

      it "will create a booking if schedule is valid, contact_information is valid, tentative_lineup is valid and online_link is valid" do 
        expect {Booking.guest_create_booking({booking: booking, contact_information: contact_information, online_link: online_link, tentative_lineup: tentative_lineup})     
               }.to change{Booking.count}.from(0).to (1)
      end 

      it "will not create a booking if schedule is invalid" do  
        booking[:schedule_id] = schedule_closed.id
        expect {Booking.guest_create_booking({booking: booking, contact_information: contact_information, online_link: online_link, tentative_lineup: tentative_lineup})     
               }.not_to change{Booking.count}
      end
      it "will not create a booking if tentative lineup is missing" do  
        expect {Booking.guest_create_booking({booking: booking, contact_information: contact_information, online_link: online_link})     
               }.not_to change{Booking.count}
      end
      it "will not create a booking if contact_information is missing" do  
        expect {Booking.guest_create_booking({booking: booking, contact_information: nil, online_link: online_link, tentative_lineup: tentative_lineup})     
               }.not_to change{Booking.count}
      end
      it "will not create a booking if there is no online link" do  
        expect {Booking.guest_create_booking({booking: booking, contact_information: contact_information, tentative_lineup: tentative_lineup})     
               }.not_to change{Booking.count}
      end
    end
  end

  describe '#temporarily_close_schedule' do 
    context 'when status is pending' do 
      it "will close the schedule availability" do 
        expect {Booking.create!(name: "booking_1", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "pending", contact_information: user)
              }.to change{production_schedule.availability}.from(true). to(false)
      end
    end

    context 'when status is approved' do 
      it "will not change the schedule availability" do 
        expect {Booking.create!(name: "booking_1", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "approved", contact_information: user)
                }.not_to change{production_schedule.availability}
      end
    end
  end

  describe '#update_related_bookings' do 
    before(:each) do 
      allow_any_instance_of(Booking).to receive_messages(:temporarily_close_schedule => nil)
      @booking_1 = Booking.create!(name: "booking_1", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "denied", contact_information: user)
      @booking_2 = Booking.create!(name: "booking_2", description: "type of booking", previous_events: "at intramuros", schedule: production_schedule, status: "pending", contact_information: user)
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