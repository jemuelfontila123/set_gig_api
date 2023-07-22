require 'rails_helper'


RSpec.describe Admin, type: :model do 

  subject {
    described_class.new(username: "anything", password: "minimumisten")
  }

  it "is valid with valid attributes" do 
    expect(subject).to be_valid 
  end

  it "is not valid without username" do 
    subject.username = nil 
    expect(subject).not_to be_valid
  end

  it "is not valid without password" do 
    subject.password = nil 
    expect(subject).not_to be_valid 
  end

  it "is not valid if the password's length is less than 10" do
    subject.password = "123456789"
    expect(subject).not_to be_valid 
  end 

end