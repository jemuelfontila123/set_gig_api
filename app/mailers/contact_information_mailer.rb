class ContactInformationMailer < ApplicationMailer
  # default from: 'notifications@example.com'

  def booking_success_email
    @user = params[:contact_information]
    mail(to: @user.email_address, subject: 'Booking Details')
  end

end
