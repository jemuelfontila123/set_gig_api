require 'rails_helper'

RSpec.describe 'TentativeLineups', type: :request do 

  let(:valid_admin) {create(:admin, :valid)} 

  describe '#index' do 
    context 'there are tentative lineups and admin logged in' do
      before do 
        @admin = valid_admin
        create(:schedule, :production)
        create(:schedule, :band)
        @jwt = admin_login(@admin)
        get api_v1_admin_tentative_lineups_path, headers: {"Authorization" => "Bearer #{@jwt}"}
      end

      it "will return status 200" do  
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 

      it "will return 1 tentative lineups because no lineups in production" do 
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:tentative_lineups].length).to eq(1)
      end
    end

    context 'there are no tentative lineups and admin logged in' do
      before do 
        @admin = valid_admin
        @jwt = admin_login(@admin)
        get api_v1_admin_tentative_lineups_path, headers: {"Authorization" => "Bearer #{@jwt}"}
      end

      it "will return status 200" do  
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 

      it "will return 0 tentative lineups" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:tentative_lineups].length).to eq(0)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        get api_v1_admin_tentative_lineups_path
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#show' do 
    context 'when the tentative lineup is existing' do
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :band) 
      end

      it "will return status 200" do 
        get api_v1_admin_tentative_lineup_path(3), headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:status]).to eq(200)
      end

      it "will return the existing online link" do 
        get api_v1_admin_tentative_lineup_path(4), headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:tentative_lineup][:genres].length).to eq(1)
      end
    end

    context 'when the tentative lineup is not existing' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        get api_v1_admin_tentative_lineup_path(1), headers: {"Authorization" => "Bearer #{jwt}"}
      end 

      it "will return 404 status" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        get api_v1_admin_tentative_lineup_path(6)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end

  describe '#update' do 
    context 'when the online link is existing' do
      before do
        @admin = valid_admin
        @jwt = admin_login(@admin)
        @schedule = create(:schedule, :band) 
      end

      it "will return status 200 when there is params tentative lineup regardless of its attribute" do 
        put api_v1_admin_tentative_lineup_path(5), params: {tentative_lineup: {le: '2'}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys 
        expect(json[:status]).to eq(200)
      end

      it "will update the attribute that is valid" do 
        put api_v1_admin_tentative_lineup_path(6), params: {tentative_lineup: {band_name: "Parokya"}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:tentative_lineup][:band_name]).to include('Parokya')
      end

      it "will not update when the attribute is invalid" do 
        put api_v1_admin_tentative_lineup_path(7), params: {tentative_lineup: {genres: "aw"}}, headers: {"Authorization" => "Bearer #{@jwt}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when the tentative lineup is not existing' do 
      before do 
        @admin = valid_admin
        jwt = admin_login(@admin)
        put api_v1_admin_tentative_lineup_path(1), params: {tentative_lineup: {band_name: "Parokya"}}, headers: {"Authorization" => "Bearer #{jwt}"}
      end 

      it "will return 404 status" do 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
      end
    end

    context 'when admin is not logged in' do  
      it "will return a 401 error" do 
        put api_v1_admin_tentative_lineup_path(11)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end
end 