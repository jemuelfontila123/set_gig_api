class Api::V1::Guest::BaseController < ApplicationController 

  private 

  def set_user 
    @user = User.find(@jwt_payload['data']) 
  end 
  
end