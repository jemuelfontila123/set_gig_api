class Booking < ApplicationRecord 

  include ActiveModel::Validations

  belongs_to :schedule

  has_one :online_link, dependent: :destroy
  has_one :contact_information, dependent: :destroy
  has_one :tentative_lineup, dependent: :destroy

  enum status: {pending: 0, denied: 1, approved: 2}

  validates_with Validators::BookingValidator 
  validates :name, presence: true
  validates :description, presence: true

  default_scope {order(created_at: :asc)}
end