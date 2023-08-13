require 'rails_helper'

RSpec.describe 'Bookings', type: :request do 

  describe '#create' do  
    context do 'contact information and online link will be intertwined to booking'
      before do
        @schedule = create(:schedule, :production_open) 
        @booking = {name: "bobook", schedule_id: @schedule.id, previous_events: "test", description: "test"}
        @contact_information = {first_name: "jim", last_name: "tests", email_address: "tests123@gmail.com", mobile_number: "09196022579"}
        @online_link = {url: "facebook.com"} 
      end  

      it "will create the boooking if the the booking attributes, contact_information attributes and the online_link attributes are valid" do 
        post api_v1_guest_bookings_path, params: {booking: @booking, contact_information: @contact_information, online_link: @online_link}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:success_message]).to include("Booking successfully made")
      end  

      it "will be invalid if booking is invalid even if all the association attributes are valid" do 
        @booking[:name] = nil
        post api_v1_guest_bookings_path, params: {booking: @booking, contact_information: @contact_information, online_link: @online_link} 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:error_message]).to include("Validation failed")
      end

      it "will be invalid if contact_information attributes are invalid" do 
        @contact_information[:first_name] = nil
        post api_v1_guest_bookings_path, params: {booking: @booking, contact_information: @contact_information, online_link: @online_link} 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:error_message]).to include("Validation failed")
      end

      it "will be invalid if online_link attributes are invalid" do 
        @online_link[:url] = nil
        post api_v1_guest_bookings_path, params: {booking: @booking, contact_information: @contact_information, online_link: @online_link} 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:error_message]).to include("Validation failed")
      end
    end
  end
end 