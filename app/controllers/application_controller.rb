class ApplicationController < ActionController::API 
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods 
  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  private 
  
  def require_login
    if token_exists?
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

  def encode(payload, exp=1.hours.from_now) 
    JWT.encode({data: payload, exp: exp.to_i},Rails.application.secrets.secret_key_base)
  end

  def decode(token)
    body = JWT.decode(token, Rails.application.secrets.secret_key_base)
    if body.present? 
      return body[0]
    else 
      return nil 
    end 
  end 

  def token_exists? 
    request.headers['Authorization'].present?  
  end

  def record_not_found(exception)
    render json: {error: exception.message, status: 404} 
  end
end
