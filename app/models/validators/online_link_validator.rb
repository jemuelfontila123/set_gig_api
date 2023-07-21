class Validators::OnlineLinkValidator < ActiveModel::Validator 
  
  def validate(record)
    record.errors.add(:url, "does not exists") unless is_uri_existing?(record.url)
  end

  def is_uri_existing?(link)
    begin 
      URI.open(link)
    rescue SocketError 
      return false 
    rescue StandardError => e 
      return false 
    end 
    true 
  end

end