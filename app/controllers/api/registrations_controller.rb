class Api::RegistrationsController < Api::BaseController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def create
    issuance = Issuance.find params[:issuance_id]
    if issuance.registration_secret == passed_registration_secret
      registration = issuance.registrations.new
      registration.push_token = params[:pushToken]
      registration.device_library_identifier = params[:device_library_identifier]
      registration.save
      render :nothing => true, :status => :created
    else
      render :nothing => true, :status => :unauthorized
    end
  end

  def destroy
    issuance = Issuance.find params[:issuance_id]
    if issuance.registration_secret == passed_registration_secret
      issuance.registrations.where(:device_library_identifier => params[:device_library_identifier]).destroy_all
      render :nothing => true
    else
      render :nothing => true, :status => :unauthorized
    end
  end

  def index
    registrations = Registration.where :device_library_identifier => params[:device_library_identifier]
    registrations = registrations.where 'updated_at > ?', DateTime.parse(params[:passesUpdatedSince]) if params[:passesUpdatedSince]
    if registrations.count == 0
      render :nothing => true, :status => :no_content
    else
      render :json => {:lastUpdated => Time.now.utc.iso8601, :serialNumbers => registrations.map(&:id).map(&:to_s)}, :status => :ok
    end
  end

  def show
    issuance = Issuance.find params[:issuance_id]
    if issuance.registration_secret == passed_registration_secret
      if Time.parse(request.headers['if-modified-since']).to_i < issuance.updated_at.to_i
        headers['last-modified'] = issuance.updated_at.utc.iso8601
        send_file issuance.path, :content_type => :pkpass
      else
        render :nothing => true, :status => :not_modified
      end
    else
      render :nothing => true, :status => :unauthorized
    end
  end

private

  def passed_registration_secret
    request.headers['authorization'].match(/^ApplePass (.+)$/)[1]
  end

  def record_not_found
    render :nothing => true, :status => :unauthorized
  end

end
