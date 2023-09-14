class Booking < ApplicationRecord 

  include ActiveModel::Validations

  belongs_to :schedule 
  belongs_to :contact_information


  has_one :online_link, dependent: :destroy
  has_one :tentative_lineup, dependent: :destroy

  enum status: {pending: 0, denied: 1, approved: 2}

  validates_with Validators::BookingValidator 
  validates :name, presence: true
  validates :description, presence: true

  default_scope {order(created_at: :asc)}  

  after_commit :temporarily_close_schedule, on: :create, if: Proc.new {|obj| obj.pending?} 
  after_commit :update_related_bookings, on: :update, if: Proc.new { |obj| obj.saved_change_to_status? && obj.approved?}

  WAITING_TIME = 3.hours 

  def update_related_bookings 
    bookings_to_update = schedule.bookings.where.not(id: id)  
    bookings_to_update.update_all(status: Booking.statuses[:denied])  
  end

  def temporarily_close_schedule 
    schedule.update(availability: false)
    OpenScheduleJob.set(wait: WAITING_TIME).perform_later(schedule)
  end
 

  # Needs to fix this and add rspec
  def self.guest_create_booking(opts = {})
    ActiveRecord::Base.transaction do 
      guest = ContactInformation.create!(opts[:contact_information])
      @booking = guest.bookings.create!(opts[:booking])
      @booking.create_online_link!(opts[:online_link])  
      @booking.create_contact_information!(opts[:contact_information])  
      @booking.create_tentative_lineup!(opts[:tentative_lineup]) if @booking.schedule.band?
    end
    return @booking
  rescue ActiveRecord::RecordInvalid => e
    return e.message
  end  

end