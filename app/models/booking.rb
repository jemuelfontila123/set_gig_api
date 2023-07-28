class Booking < ApplicationRecord 

  include ActiveModel::Validations

  belongs_to :schedule
  
  enum status: {pending: 0, denied: 1, approved: 2}

  validates_with Validators::BookingValidator 
  validates :name, presence: true
  validates :description, presence: true

end