class OnlineLink < ApplicationRecord 

  include ActiveModel::Validations
  validates_with Validators::OnlineLinkValidator 
  validates :url, presence: true
  validates :link_type, presence: true
    
  belongs_to :booking

end