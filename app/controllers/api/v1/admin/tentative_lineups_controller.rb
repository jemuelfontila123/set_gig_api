class Api::V1::Admin::TentativeLineupsController < Api::V1::Admin::BaseController
  before_action :set_tentative_lineup
  before_action :require_login 
  
  def index 
    tentative_lineups = TentativeLineup.all
    render json: {tentative_lineups: tentative_lineups, status: 200}
  end  

  def show  
    if @tentative_lineup.present? 
      render json: {tentative_lineup: @tentative_lineup, status: 200}
    else 
      render json: {error_message: "An error has occured", status: 404} 
    end 
  end
  
  def update 
    begin 
      if @tentative_lineup.present? && @tentative_lineup.update(tentative_lineup_params) 
        render json: {tentative_lineup: @tentative_lineup, status: 200} 
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

  def tentative_lineup_params
    params.require(:tentative_lineup).permit(:band_name, :genres)
  end 

  def set_tentative_lineup
    if params[:id].present? 
      @tentative_lineup = TentativeLineup.find(params[:id]) rescue nil 
    else
      @tentative_lineup = nil 
    end 
  end 

end