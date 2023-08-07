require 'rails_helper'

RSpec.describe 'ContactInformations', type: :request do 

  let(:valid_admin) {create(:admin, :valid)} 

  describe '#index' do 
    context 'there are contact_informations and admin logged in' do
      before do 
        @admin = valid_admin
        create(:schedule, :production)
        create(:schedule, :band)
        @jwt = admin_login(@admin)
        get api_v1_admin_contact_informations_path, headers: {"Authorization" => "Bearer #{@jwt}"}
      end

      it "will return status 200" do  
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 

      it "will return the bookings" do 
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:contact_informations].length).to eq(2)
      end
    end

    context 'there are no contact_informations and admin logged in' do
      before do 
        @admin = valid_admin
        @jwt = admin_login(@admin)
        get api_v1_admin_contact_informations_path, headers: {"Authorization" => "Bearer #{@jwt}"}
      end

      it "will return status 200" do  
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 

      it "will return the bookings" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:contact_informations].length).to eq(0)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        get api_v1_admin_contact_informations_path
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#show' do 
    context 'when the contact information is existing' do
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
      end

      it "will return status 200" do 
        get api_v1_admin_contact_information_path(5), headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:status]).to eq(200)
      end

      it "will return the existing contact information" do 
        get api_v1_admin_contact_information_path(6), headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:contact_information][:first_name]).to eq('Jemu')
      end
    end

    context 'when the contact information is not existing' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        get api_v1_admin_contact_information_path(1), headers: {"Authorization" => "Bearer #{jwt}"}
      end 

      it "will return 404 status" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        get api_v1_admin_contact_information_path(1)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#update' do 
    context 'when the schedule is existing' do
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
      end

      it "will return status 200 when there is params booking regardless of its attribute" do 
        put api_v1_admin_contact_information_path(7), params: {contact_information: {le: '2'}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:status]).to eq(200)
      end

      it "will update the attribute that is valid" do 
        put api_v1_admin_contact_information_path(8), params: {contact_information: {first_name: "testing123"}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:contact_information][:first_name]).to eq('testing123')
      end

      it "will not update when the attribute is invalid" do 
        put api_v1_admin_contact_information_path(9), params: {contact_information: {first_name: ""}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when the booking is not existing' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        put api_v1_admin_contact_information_path(1), params: {contact_information: {test: 1}}, headers: {"Authorization" => "Bearer #{jwt}"}
      end 

      it "will return 404 status" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        put api_v1_admin_contact_information_path(11)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end 
end 