class RemoveBookingTypeFromBookings < ActiveRecord::Migration[7.0]
  def 
    remove_column :bookings, :booking_type, :integer
  end
end
