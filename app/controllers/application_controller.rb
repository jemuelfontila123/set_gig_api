class ApplicationController < ActionController::API 

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
  
end
