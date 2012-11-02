class Api::RegistrationsController < Api::BaseController

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
      render :nothing => true, :status => :ok
    else
      render :nothing => true, :status => :unauthorized
    end
  end

  def index
    registrations = Registration.where :device_library_identifier => params[:device_library_identifier]
    registrations.where 'updated_at > ?', DateTime.parse(params[:passesUpdatedSince]) if params[:passesUpdatedSince]
    render :json => {:lastUpdated => registrations.map(&:updated_at).max, :serialNumbers => registrations.map(&:id).map(&:to_s)}, :status => :ok
  end

  def show
    issuance = Issuance.find params[:issuance_id]
    if issuance.registration_secret == passed_registration_secret
      render :nothing => true, :status => :not_modified
    else
      render :nothing => true, :status => :unauthorized
    end
  end

private

  def passed_registration_secret
    request.headers['authorization'].match(/^ApplePass (.+)$/)[1]
  end

end
