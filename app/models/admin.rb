class Admin < ApplicationRecord 
  has_secure_password 
  
  
  include ActiveModel::Validations
  validates_with Validators::AdminValidator 
  validates :password, length: {minimum: 10}, presence: true
  validates :username, uniqueness: true, presence: true
  
end