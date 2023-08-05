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
  end
end 