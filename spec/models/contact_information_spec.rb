require 'rails_helper'

RSpec.describe ContactInformation, type: :model do 

  
  let(:band_schedule) {
    Schedule.new(start_time: DateTime.new(2023,7,24,19), end_time: DateTime.new(2023,7,24,19,30), schedule_type: Schedule.schedule_types[:band])
  }

  let(:booking) {
    Booking.new(name: "booking", description: "type of booking", previous_events: "at intramuros", schedule: band_schedule )
  }

  subject {
    described_class.new(first_name: 'Jemuel', last_name: 'Fontila', mobile_number: '09126022573', email_address: 'jemuel123@gmail.com', booking: booking)
  }

  it "is is valid with valid attributes" do 
    expect(subject).to be_valid 
  end

  it "is still valid without last name (must be optional)" do 
    subject.last_name = nil
    expect(subject).to be_valid 
  end

  it "is invalid without booking" do 
    subject.booking = nil 
    expect(subject).not_to be_valid
  end

  it "is invalid without first_name" do 
    subject.first_name = nil 
    expect(subject).not_to be_valid 
  end 

  describe 'mobile_number' do 
    context 'with invalid format' do 
      it "will fail" do 
        subject.mobile_number = '12345678911'
        expect(subject).not_to be_valid
      end
    end 
    
    context 'with valid format but less than 11  numbers' do
      it "will fail" do 
        subject.mobile_number ='0919602257'
        expect(subject).not_to be_valid
      end
    end

    context 'with no mobile number' do 
      it "will fail" do 
        subject.mobile_number = nil 
        expect(subject).not_to be_valid 
      end 
    end
  end

  describe 'email_address' do 

    context 'with no email address' do 
      it "will fail" do 
        subject.email_address = nil 
        expect(subject).not_to be_valid 
      end  
    end
   
    context 'with invalid format' do 
      it "will fail" do 
        subject.email_address = "jemuel123.gmail" 
        expect(subject).not_to be_valid 
      end 
    end 
  end


end