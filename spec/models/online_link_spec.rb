require 'rails_helper'

RSpec.describe OnlineLink, type: :model do 
  
  let(:schedule) { 
    Schedule.new(start_time: DateTime.new(2023,7,23,19), end_time: DateTime.new(2023,7,24,1), schedule_type: Schedule.schedule_types[:production])
  } 
  let(:booking) { Booking.new()}
  subject {
    described_class.new(url: 'https://www.betterspecs.org/', link_type: 'blog') 
  }


  it "is valid with valid attributes" do 
    expect(subject).to be_valid 
  end

  it "is invalid without url" do 
    subject.url = nil 
    expect(subject).not_to be_valid 
  end 


end