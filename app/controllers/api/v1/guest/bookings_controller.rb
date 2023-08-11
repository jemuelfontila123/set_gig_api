class Api::V1::Guest::BookingsController < ApplicationController 
  
  def create 
    booking = Booking.create_booking(booking_params)
    unless booking.instance_of? String
      render json: booking , include: ['contact_information', 'online_link']
    else 
      render json: {error_message: booking, status: 404}
    end
  end 

  private 

  def booking_params
    params.permit(booking: [:status, :name, :description, :previous_events, :schedule_id],
                  contact_information: [:first_name, :last_name, :email_address, :mobile_number], 
                  online_link: [:link_type, :url],
                  tentative_lineup: [:band_name, :genres]
                 ) 
  end 


end