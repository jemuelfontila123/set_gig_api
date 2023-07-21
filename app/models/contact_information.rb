class ContactInformation < ApplicationRecord 
  
  validates :mobile_number, length: {maximum: 11}, presence: true
  validates :email, presence: true
  validates :first_name, presence: true 
  
  belongs_to :booking
end