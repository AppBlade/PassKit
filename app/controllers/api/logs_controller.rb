class Api::LogsController < Api::BaseController

  def create
    Rails.logger.info params[:logs]
    render :nothing => true
  end

end
