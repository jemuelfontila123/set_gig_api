class Admin < ApplicationRecord 
  has_secure_password 
  
  # Add password complexity later on
  validates :password, length: {minimum: 10}
  validates :username, uniqueness: true, presence: true
end