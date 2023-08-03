require 'rails_helper'

RSpec.describe 'Schedules', type: :request do 
  let(:valid_admin) {create(:admin, :valid)}

  describe '#index' do 
    context 'when there is schedules and admin logged in' do 
      before do 
        @admin = valid_admin
        create(:schedule, :production)
        create(:schedule, :band)
        jwt = admin_login(@admin)
        get api_v1_admin_schedules_path, headers: { "Authorization" => "Bearer #{jwt}"}
      end
      it "will return status 200" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end

      it "will return the production schedules" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:production_schedules].length).to eq(1)
      end

      it "will return the band schedules" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:band_schedules].length).to eq(1)
      end
    end

    context 'when there is no schedules and admin logged in' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        get api_v1_admin_schedules_path, headers: { "Authorization" => "Bearer #{jwt}"}
      end
      it "will return status 200" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end

      it "will return no production schedules" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:production_schedules].length).to eq(0)
      end

      it "will return no band schedules" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:band_schedules].length).to eq(0)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        get api_v1_admin_schedules_path 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#show' do 
    context 'when the schedule is existing' do
      before do
        @admin = valid_admin
        jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
        get api_v1_admin_schedule_path(1), headers: {"Authorization" => "Bearer #{jwt}"}
      end

      it "will return status 200" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end

      it "will return the existing schedule" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:schedule][:id]).to eq(@schedule.id)
      end
    end

    context 'when the schedule is not existing' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        get api_v1_admin_schedule_path(1), headers: {"Authorization" => "Bearer #{jwt}"}
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
    context 'when schedule exists' do
      before do
        @admin = create(:admin, :valid)
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
      end
      it "will return status 200 when there is params schedule regardless of its attribute" do 
        put api_v1_admin_schedule_path(1), params: { schedule: {id: 1 } }, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end

      it "will update the attribute that is valid" do 
        put api_v1_admin_schedule_path(1), params: {schedule: {availability: true}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:schedule][:availability]).to be_truthy
      end 

      it "will not update when the attribute is invalid" do 
        put api_v1_admin_schedule_path(1), params: {schedule: {schedule_type: "band"}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when schedule does not exists' do 
      before do
        @admin = create(:admin, :valid)
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
      end 

      it "will return a status 404" do 
        put api_v1_admin_schedule_path(2), params: {schedule: {availability: true}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        put api_v1_admin_schedule_path(1), params: {schedule: {schedule_type: "production"}}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#create' do 
    context 'when schedule does not exists' do
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
      end
      it "will return status 200 when the attributes are valid" do 
        schedule = {start_time: DateTime.new(2023,7,22,19), end_time: DateTime.new(2023,7,23,1), schedule_type: "production"}
        post api_v1_admin_schedules_path, params: {schedule: schedule}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end
      
      it "will return status 404 when the attributes are invalid" do 
        schedule = {start_time: DateTime.new(2023,7,22,19,30), end_time: DateTime.new(2023,7,23,1), schedule_type: "production"} 
        post api_v1_admin_schedules_path, params: {schedule: schedule}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end 

    context 'when schedule exists' do 
      before do 
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
      end
      it "will return status 404" do 
        schedule = {start_time: DateTime.new(2023,7,23,19), end_time: DateTime.new(2023,7,24,1), schedule_type: "production"}
        post api_v1_admin_schedules_path, params: {schedule: schedule}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end
  end
end
