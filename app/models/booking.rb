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

  after_create_commit :temporarily_close_schedule, on: :create 

  WAITING_TIME = 3.hours

  def temporarily_close_schedule 
    schedule.update(availability: false)
    OpenScheduleJob.set(wait: WAITING_TIME).perform_later(schedule)
  end

  def self.create_booking(opts = {})
    Booking.transaction do 
      @booking = Booking.create!(opts[:booking])
      @booking.create_online_link!(opts[:online_link])  
      @booking.create_contact_information!(opts[:contact_information])  
      @booking.create_tentative_lineup!(opts[:tentative_lineup]) if opts[:tentative_lineup].present? 
    end
    return @booking
  rescue ActiveRecord::RecordInvalid => e
    return e.message
  end
end