class ApplicationController < ActionController::API 
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods 
  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  private 

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

  def record_not_found(exception)
    render json: {error: exception.message, status: 404} 
  end
end
