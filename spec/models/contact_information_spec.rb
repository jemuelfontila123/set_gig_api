require 'rails_helper'

RSpec.describe ContactInformation, type: :model do 

  let(:subject){
    described_class.new(first_name: 'Jemuel', last_name: 'Fontila', mobile_number: '09126022573', email_address: 'jemuel123@gmail.com')
  } 

  context 'when it is a user' do 
    before do 
      subject.contact_type = ContactInformation.contact_types[:user]
      subject.password = "Minimumisten1#"
    end 

    it "is valid with valid attributes" do 
      expect(subject).to be_valid
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
  
  it "is is valid with valid attributes" do
    expect(subject).to be_valid 
  end

  it "is still valid without last name (must be optional)" do 
    subject.last_name = nil
    expect(subject).to be_valid 
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