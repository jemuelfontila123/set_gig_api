class Api::V1::Admin::AuthenticationController < Api::V1::Admin::BaseController 
  
  def create 
    admin = Admin.find_by_username(params[:username])
    if admin&.authenticate(params[:password])
      token = encode(admin)
      render json: {token: token, admin: admin, status: 200}
    else 
      render json: {status: 401, error: "Authentication failed "}
    end 
   end 
end