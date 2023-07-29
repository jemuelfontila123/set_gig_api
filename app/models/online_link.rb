class OnlineLink < ApplicationRecord 

  include ActiveModel::Validations
  validates_with Validators::OnlineLinkValidator 
  validates :url, presence: true
  validates :link_type, presence: true
  before_validation :format_website

    
  belongs_to :booking

  
  def format_website
    if self.url.present?
      self.url = "https://www.#{self.url}" unless self.url[/^https?/]
      self.link_type = URI(self.url).host
    end
  end

end