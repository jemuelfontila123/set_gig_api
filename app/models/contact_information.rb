class ContactInformation < ApplicationRecord 
  
  include ActiveModel::Validations

  validates_with Validators::ContactInformationValidator
  validates :mobile_number, length: {minimum:11, maximum: 11}, presence: true
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true 
  
  belongs_to :booking, dependent: :destroy
end