class OnlineLink < ApplicationRecord 
    include ActiveModel::Validations
    validates_with Validators::OnlineLinkValidator 
    validates :url, presence: true
    
    belongs_to :booking
end