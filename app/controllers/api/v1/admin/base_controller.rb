class Api::V1::Admin::BaseController < ApplicationController 
   
  private 
  def require_login
    if request.headers['Authorization'].present? 
      authenticate_or_request_with_http_token do |token|
        begin
          @jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          render json: {status: 401, error: "authentication failed"}
        end
      end
    else
      render json: {status:401, error: "not authorized"}
    end
  end

  def set_admin 
    p @jwt_payload
  end

end