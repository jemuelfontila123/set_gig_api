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
    if @booking.present? && @booking.update(booking_params) 
      render json: {booking: @booking, status: 200} 
    else 
      render json: {error_message: "An error has occured", status: 404} 
    end 
  end 

  private  

  def booking_params
    parameters.require(:booking).permit(:status, :name, :description, :previous_events) 
  end 

  def contact_information_params 
    parameters.require(:contact_information).permit(:first_name, :last_name, :mobile_number, :email_address)
  end 

  def schedule_params 
    parameters.require(:schedule).permit(:id)
  end 

  def online_link_params 
    parameters.require(:online_link).permit(:link_type, :url)
  end

  def tentative_lineup_params 
    parameters.require(:tentative_lineup).permit(:band_name, :genres)
  end 

  def set_booking 
    if params[:id].present?
      @booking = Booking.find(params[:id]) rescue nil 
    else 
      @booking = nil 
    end 
  end 

end