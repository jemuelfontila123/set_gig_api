class Api::V1::Guest::BookingsController < ApplicationController 
  
  def create 
    booking = Booking.create_booking(booking_params)
    unless booking.instance_of? String
      render json: {success_message: 'Booking successfully made. Please wait for an email', status: 200}
    else 
      render json: {error_message: booking, status: 404}
    end
  end 

  private 

  def booking_params
    params.permit(booking: [:status, :name, :description, :previous_events, :schedule_id],
                  contact_information: [:first_name, :last_name, :email_address, :mobile_number], 
                  online_link: [:url],
                  tentative_lineup: [:band_name, :genres]
                 ) 
  end


end