require 'rails_helper'

RSpec.describe OnlineLink, type: :model do 
  
  let(:booking) { Booking.new()}
  subject {
    described_class.new(url: 'https://www.betterspecs.org/', link_type: 'blog') 
  }


  it "is valid with valid attributes" do 
    expect(subject).to be_valid 
  end

end