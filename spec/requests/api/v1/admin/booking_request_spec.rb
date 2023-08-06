require 'rails_helper'

RSpec.describe 'Bookings', type: :request do 

  let(:valid_admin) {create(:admin, :valid)} 

  describe '#index' do 
    context 'there are bookings and admin logged in' do
      before do 
        @admin = valid_admin
        create(:schedule, :production)
        create(:schedule, :band)
        @jwt = admin_login(@admin)
        get api_v1_admin_bookings_path, headers: {"Authorization" => "Bearer #{@jwt}"}
      end

      it "will return status 200" do  
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 

      it "will return the bookings" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:bookings].length).to eq(2)
      end
    end

    context 'there are no bookings and admin logged in' do
      before do 
        @admin = valid_admin
        @jwt = admin_login(@admin)
        get api_v1_admin_bookings_path, headers: {"Authorization" => "Bearer #{@jwt}"}
      end

      it "will return status 200" do  
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 

      it "will return the bookings" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:bookings].length).to eq(0)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        get api_v1_admin_bookings_path
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#show' do 
    context 'when the booking is existing' do
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
      end

      it "will return status 200" do 
        get api_v1_admin_booking_path(5), headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:status]).to eq(200)
      end

      it "will return the existing booking" do 
        get api_v1_admin_booking_path(6), headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:booking][:name]).to eq('band booking')
      end
    end

    context 'when the booking is not existing' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        get api_v1_admin_booking_path(1), headers: {"Authorization" => "Bearer #{jwt}"}
      end 

      it "will return 404 status" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        get api_v1_admin_schedule_path(1)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#update' do 
    context 'when the booking is existing' do
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
      end

      it "will return status 200 when there is params booking regardless of its attribute" do 
        put api_v1_admin_booking_path(7), params: {booking: {test: 2}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:status]).to eq(200)
      end

      it "will update the attribute that is valid" do 
        put api_v1_admin_booking_path(8), params: {booking: {name: "test booking"}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:booking][:name]).to eq('test booking')
      end

      it "will not update when the attribute is invalid" do 
        put api_v1_admin_booking_path(9), params: {booking: {status: 1}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when the booking is not existing' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        put api_v1_admin_booking_path(1), params: {booking: {name: "test booking"}}, headers: {"Authorization" => "Bearer #{jwt}"}
      end 

      it "will return 404 status" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        put api_v1_admin_booking_path(11)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end 

  describe '#create' do  
    context do 'when admin is logged in'
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
        @booking = {name: "bobook", schedule_id: @schedule.id, previous_events: "test", description: "test"}
        @contact_information = {first_name: "jim", last_name: "tests", email_address: "tests123@gmail.com", mobile_number: "09196022579"}
        @online_link = {url: "facebook.com"} 
      end  

      it "will create the booking when the attributes are valid" do 
        post api_v1_admin_bookings_path, params: {booking: @booking}, headers: {"Authorization" => "Bearer #{@jwt}"} 
        expect(Booking.count).to eq(1)
      end 

      it "will create the booking and contact information when the attributes are valid" do 
        post api_v1_admin_bookings_path, params: {booking: @booking, contact_information: @contact_information}, headers: {"Authorization" => "Bearer #{@jwt}"} 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:contact_information][:first_name]).to eq(@contact_information[:first_name])
      end 

      it "will create the booking and online link when the attributes are valid" do 
        post api_v1_admin_bookings_path, params: {booking: @booking, contact_information: @contact_information, online_link: @online_link}, headers: {"Authorization" => "Bearer #{@jwt}"} 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:online_link][:url]).to include(@online_link[:url])
      end 

    end 
  end
  


end 