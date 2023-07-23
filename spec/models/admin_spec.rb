require 'rails_helper'


RSpec.describe Admin, type: :model do 

  subject {
    described_class.new(username: "anything", password: "Minimumisten1#")
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
  
  it "is not valid if the password has no 1 uppercase" do 
    subject.password = "minimumisten1#"
    expect(subject).not_to be_valid 
  end

  it "is not valid if the password has no 1 special character" do 
    subject.password = "Minimumisten1"
    expect(subject).not_to be_valid 
  end

  it "is not valid if the password has no 1 number" do 
    subject.password = "Minimumisten#"
    expect(subject).not_to be_valid 
  end

end