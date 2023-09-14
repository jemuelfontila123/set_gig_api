class ChangeForeignKeyForBookingAndContactInformation < ActiveRecord::Migration[7.0]
  def change 
    remove_reference :contact_informations, :booking
    add_reference :bookings, :contact_information, index: true, foreign_key: true
  end
end
