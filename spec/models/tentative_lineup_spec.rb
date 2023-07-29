require 'rails_helper'

RSpec.describe TentativeLineup, type: :model do 
 
  let(:band_schedule) {
    Schedule.new(start_time: DateTime.new(2023,7,24,19), end_time: DateTime.new(2023,7,24,19,30), schedule_type: Schedule.schedule_types[:band])
  }

  let(:production_schedule) { 
    Schedule.new(start_time: DateTime.new(2023,7,23,19), end_time: DateTime.new(2023,7,24,1), schedule_type: Schedule.schedule_types[:production])
  } 

  let(:booking) {
    Booking.new(name: "booking", description: "type of booking", previous_events: "at intramuros", schedule: band_schedule )
  }

  subject {
    described_class.new(band_name: 'Gloc 9', genres: ['Pop', 'Rock'], booking: booking)
  } 

  describe 'booking' do 
    it "will be invalid without booking" do 
      subject.booking = nil 
      expect(subject).not_to be_valid 
    end 
    
    it "will be invalid with production booking" do 
      subject.booking.schedule = production_schedule 
      expect(subject).not_to be_valid   
    end 

    it "will be valid with band booking" do 
      expect(subject).to be_valid
    end 
  end 

  it "will be invalid without band name" do 
    subject.band_name = nil 
    expect(subject).not_to be_valid
  end

  it "will be invalid without any type of genre" do 
    subject.genres = nil 
    expect(subject).not_to be_valid
  end


end