require 'rails_helper'

RSpec.describe Schedule, type: :model do 
    subject{
        described_class.new(start_time: DateTime.now, end_time: DateTime.now.end_of_day)
    }

  it "is valid with valid attributes" do 
    expect(subject).to be_valid 
  end

  it "is not valid without start_time" do 
    subject.start_time = nil 
    expect(subject).not_to be_valid 
  end

  it "is not valid without start_time" do 
    subject.end_time = nil 
    expect(subject).not_to be_valid 
  end
end