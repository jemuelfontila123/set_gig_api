require 'rails_helper'

RSpec.describe Schedule, type: :model do 

  
  subject {
    Schedule.new(start_time: DateTime.new(2023,7,23,19), end_time: DateTime.new(2023,7,24,1), schedule_type: Schedule.schedule_types[:production])
  }

  describe 'production schedule' do 
    context 'when the date is on the weekends' do 

      it "will be valid when the start_time is 7pm and the end_time is 1am" do
        expect(subject).to be_valid 
      end

      it "will be not valid when the start_time is not 7pm" do
        subject.start_time = DateTime.new(2023,7,23,18)
        expect(subject).not_to be_valid 
      end

      it "will not be valid when the start_time is correct but the end_time is  not 1am" do 
        subject.end_time = DateTime.new(2023,7,24,2)
        expect(subject).not_to be_valid
      end
    end

    context 'when the date is not on the weekends' do 
    
      it "will be invalid even if the starting hour and ending hour is correct" do 
        subject.start_time = DateTime.new(2023,7,24,19)
        subject.end_time = DateTime.new(2023,7,25,1) 
        expect(subject).not_to be_valid
      end

    end

  end

  describe 'band schedule' do 
    context 'when the date is on the weekdays' do 

      before do 
        subject.schedule_type = Schedule.schedule_types[:band]
        subject.start_time = DateTime.new(2023,7,24,19)
        subject.end_time = DateTime.new(2023,7,24,19,30)
      end
      
      it "will be valid when the start time is between 7 pm - 12:30 am, 30 minutes iteration per start_time and the end time is 30 minutes after the start_time" do 
        expect(subject).to be_valid
      end

      it "will be invalid even if the start time is between 7pm to 1am if the minutes is not 0 or 30" do 
        subject.start_time = DateTime.new(2023,7,24,19,45) 
        expect(subject).not_to be_valid 
      end 

      it "will be invalid if the end time is not 30 minutes after the start time" do 
        subject.end_time = DateTime.new(2023,7,24,19,45) 
        expect(subject).not_to be_valid 
      end
    end

    context 'when the date is on the weekends' do 

      before do 
        subject.schedule_type = Schedule.schedule_types[:band]
        subject.start_time = DateTime.new(2023,7,22)
        subject.end_time = DateTime.new(2023,7,22,0,30)
      end 

      it "will be valid when the start time is saturday and the hour is either 12:00am or 12:30 am" do 
        expect(subject).to be_valid
      end

      it "will be invalid when the start time is saturday and the hour is not 12:00 am or 12:30 am" do 
        subject.start_time = DateTime.new(2023,7,22,0,45) 
        expect(subject).not_to be_valid
      end

      it "will be invalid when the start time is sunday and the hour is correct" do 
        subject.start_time = DateTime.new(2023,7,23)
        subject.end_time = DateTime.new(2023,7,23,0,30)
        
        expect(subject).not_to be_valid
      end
    end


  end

  
end