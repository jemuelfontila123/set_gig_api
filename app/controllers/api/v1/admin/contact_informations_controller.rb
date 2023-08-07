
class Api::V1::Admin::ContactInformationsController < Api::V1::Admin::BaseController 

  before_action :set_contact_information
  before_action :require_login 
  
  def index 
    contact_informations = ContactInformation.all
    render json: {contact_informations: contact_informations, status: 200}
  end  

  def show  
    if @contact_information.present? 
      render json: {contact_information: @contact_information, status: 200}
    else 
      render json: {error_message: "An error has occured", status: 404} 
    end 
  end
  
  def update 
    begin 
      if @contact_information.present? && @contact_information.update(contact_information_params) 
        render json: {contact_information: @contact_information, status: 200} 
      else 
        render json: {error_message: "An error has occured", status: 404} 
      end 
    rescue StandardError => e 
      render json: {error_message: e.message, status:404}
    end 
  end  

  # Need to create soft deletion
  def delete 
  end

  private  

  def contact_information_params
    params.require(:contact_information).permit(:first_name, :last_name, :email_address, :mobile_number)
  end 

  def set_contact_information 
    if params[:id].present? 
      @contact_information = ContactInformation.find(params[:id]) rescue nil 
    else
      @contact_information = nil 
    end 
  end 

end