class Admin::AdminsController < Admin::BaseController 
  
  def create 
    admin = Admin.find_by_username(params[:username])
    if admin&.authenticate(params[:password])
      token = encode(admin)
      render json: {token: token, admin: admin}
    else 
      render json: {error: "Authentication failed "}
    end 
   end 
   
end