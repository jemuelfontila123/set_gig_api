class Api::V1::Admin::BookingsController < Api::V1::Admin::BaseController 

  before_action :set_booking, only: [:show, :update] 
  before_action :require_login 
  
  def index 
    bookings = Booking.all  
    render json: {bookings: bookings, status: 200}
  end  

  def show 
    if @booking.present? 
      render json: {booking: @booking, status: 200}
    else 
      render json: {error_message: "An error has occured", status: 404} 
    end 
  end
  
  def update 
    begin 
      if @booking.present? && @booking.update(booking_params[:booking]) 
        render json: {booking: @booking, status: 200} 
      else 
        render json: {error_message: "An error has occured", status: 404} 
      end 
    rescue StandardError => e 
      render json: {error_message: e.message, status:404}
    end 
  end  

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

  def set_booking 
    if params[:id].present? 
      @booking = Booking.find(params[:id]) rescue nil 
    else
      @booking = nil 
    end 
  end 

end