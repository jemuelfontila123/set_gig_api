
class Api::V1::Admin::OnlineLinksController < Api::V1::Admin::BaseController 

  before_action :set_online_link
  before_action :require_login 
  
  def index 
    online_links = OnlineLink.all
    render json: {online_links: online_links, status: 200}
  end  

  def show  
    if @online_link.present? 
      render json: {online_link: @online_link, status: 200}
    else 
      render json: {error_message: "An error has occured", status: 404} 
    end 
  end
  
  def update 
    begin 
      if @nline_link.present? && @online_link.update(online_link_params) 
        render json: {online_link: @conline_link, status: 200} 
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

  def online_link_params
    params.require(:online_link).permit(:link_type, :url)
  end 

  def set_online_link
    if params[:id].present? 
      @online_link = OnlineLink.find(params[:id]) rescue nil 
    else
      @conline_link = nil 
    end 
  end 

end