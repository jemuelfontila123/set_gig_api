require 'rails_helper'

RSpec.describe OnlineLink, type: :model do 
  
  let(:band_schedule) {
    Schedule.new(start_time: DateTime.new(2023,7,24,19), end_time: DateTime.new(2023,7,24,19,30), schedule_type: Schedule.schedule_types[:band])
  }

  let(:booking) {
    Booking.new(name: "booking", description: "type of booking", previous_events: "at intramuros", schedule: band_schedule )
  }

  subject {
    described_class.new(url: 'https://www.betterspecs.org', link_type: 'blog', booking: booking) 
  }


  it "is valid with valid attributes" do 
    expect(subject).to be_valid 
  end

  it "is invalid without url" do 
    subject.url = nil 
    expect(subject).not_to be_valid 
  end 

  it "is invalid with not existing/not viewable url" do 
    subject.url = 'https://githubs.com'
    expect(subject).not_to be_valid
  end

  it "is invalid without link_tyoe" do 
    subject.link_type = nil 
    expect(subject).not_to be_valid
  end


end