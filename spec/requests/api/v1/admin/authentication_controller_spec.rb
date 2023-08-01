require 'rails_helper'  

RSpec.describe Api::V1::Admin::AuthenticationController, type: :controller do 
  
  before do 
    create(:admin, :valid)
  end 

  describe '#create' do 
    context "when the admin's credential is correct" do 
      it 'will return a json with token and admin information' do 
        post :create, params: { username: 'superadmin', password: 'Minimumisten1#'}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 
    end

    context "when the admin's credential is incorrect" do 
      it 'will return an error when there is no username and password' do 
        post :
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end 

      it 'will return an error when there is no username' do 
        post :create, params: { password: 'Minimumisten1#'}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end

      it 'will return an error when there is no password' do 
        post :create, params: { username: 'superadmin' }
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end 

      it 'will return an error even if there is username and password if the password is incorrect' do  
        post :create, params: { username: 'superadmin', password: 'tenten1#2345s' }
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(401)
      end
    end
  end
end