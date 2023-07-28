class Booking < ApplicationRecord 

  belongs_to :schedule

  enum status: {pending: 0, denied: 1, approved: 2}

  validates :name, presence: true
  validates :description, presence: true
end