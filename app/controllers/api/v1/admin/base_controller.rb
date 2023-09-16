class Api::V1::Admin::BaseController < ApplicationController 
   
  private 

  def set_admin 
    @admin = Admin.find(@jwt_payload['data'])
  end

end