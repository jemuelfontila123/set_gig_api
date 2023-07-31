require 'rails_helper'  

RSpec.describe Api::V1::Admin::AuthenticationController, type: :controller do 
  
  describe '#create' do 

    context "when the admin's credential is correct" do 
      before do 
        create(:admin, :valid)
      end
      it 'will return a json with token and admin information' do 
        post :create, params: { username: 'superadmin', password: 'Minimumisten1#'}
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end 

    end
  end

end