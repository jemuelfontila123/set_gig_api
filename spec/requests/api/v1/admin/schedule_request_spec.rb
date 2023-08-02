require 'rails_helper'

RSpec.describe 'Schedules', type: :request do 

  describe '#index' do 
    context 'when there is schedules' do 
      before do 
        @admin = create(:admin, :valid)
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
     context 'when admin is not logged in' do 
        it "will return a 401 error" do 
        get api_v1_admin_schedules_path 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
        end
      end
    end


    context 'when there is no schedules' do 
      before do 
        @admin = create(:admin, :valid)
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
  end
  describe '#show' do 
    context 'when the schedule is existing' do
      before do
        @admin = create(:admin, :valid)
        jwt = admin_login(@admin)
        @schedule = create(:schedule, :production) 
        get '/api/v1/admin/schedules/:id', params: {schedule: {id: 1}}, headers: {"Authorization" => "Bearer #{jwt}"}
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
  end

end