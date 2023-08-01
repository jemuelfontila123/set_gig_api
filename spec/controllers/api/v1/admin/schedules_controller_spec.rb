require 'rails_helper'

RSpec.describe Api::V1::Admin::SchedulesController, type: :controller do 


  describe '#index' do 
    context 'when there is schedules' do 
      before do 
        create(:schedule, :production)
        create(:schedule, :band)
      end
      it "will return status 200" do 
        get :index
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end

      it "will return the production schedules" do 
        get :index 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:production_schedules].length).to eq(1)
      end

      it "will return the band schedules" do 
        get :index 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:band_schedules].length).to eq(1)
      end
    end

    context 'when there is no schedules' do 
      it "will return status 200" do 
        get :index
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end

      it "will return no production schedules" do 
        get :index 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:production_schedules].length).to eq(0)
      end

      it "will return no band schedules" do 
        get :index 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:band_schedules].length).to eq(0)
      end
    end
  end

end