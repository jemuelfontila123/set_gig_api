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

      it "will not be valid without production name" do 
        subject.schedule = band_schedule
        subject.name = nil 
        expect(subject).to_not be_valid
      end

      it "will not be valid without production description" do 
        subject.schedule = band_schedule
        subject.description = nil 
        expect(subject).to_not be_valid 
      end
      
    end

  end


end