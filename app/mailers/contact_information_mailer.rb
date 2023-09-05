class ContactInformationMailer < ApplicationMailer

  def booking_success_email
    @user = params[:contact_information]
    mail(to: @user.email_address, subject: 'Booking Details')
  end

end
