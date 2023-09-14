class ContactInformation < ApplicationRecord 
  
  include ActiveModel::Validations

  has_secure_password
  has_many :bookings, dependent: :destroy

  validates_with Validators::ContactInformationValidator
  validates :mobile_number, length: {minimum:11, maximum: 11}, presence: true
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true  
  validates :password, length: {minimum: 10}, allow_blank: false, if: Proc.new {|c| c.user?} 
  enum contact_type: {guest:0 , user: 1}
  

  before_validation :add_empty_password, if: Proc.new {|c| c.guest?}

  private 

  def add_empty_password
    self.password = self.password_confirmation = ""
    self.password_digest = "guest"
  end 

end