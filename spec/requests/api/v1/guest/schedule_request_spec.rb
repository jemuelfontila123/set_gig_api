
require 'rails_helper'

RSpec.describe 'Schedules', type: :request do 
  let(:valid_admin) {create(:admin, :valid)}

  describe '#index' do 
    context 'when there is schedules' do 
      before do 
        create(:schedule, :production)
        create(:schedule, :band)
        create(:schedule, :production_open)
        get api_v1_guest_schedules_path 
      end
      it "will only return production schedule that are available only 1 since the other two is closed" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:production_schedules].length).to eq(1)
      end 

      it "will not return any band schedule that are available since the only open is the production" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:band_schedules].length).to eq(0)
      end
    end

    context 'when there is no schedules' do 
      before do 
        get api_v1_guest_schedules_path
      end
      it "will return status 200" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end
    end 
  end
end