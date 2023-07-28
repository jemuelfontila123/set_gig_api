class Validators::OnlineLinkValidator < ActiveModel::Validator 
  require 'net/http'

  def validate(record)
    record.errors.add(:url, "does not exists") unless is_uri_existing?(record.url)
  end

  def is_uri_existing?(link)
    begin 
      uri = URI(link) 
      @response = Net::HTTP.get_response(uri) 
    rescue StandardError => e 
      return false 
    end 
    @response.is_a? Net::HTTPSuccess
  end
end