class Api::RegistrationsController < Api::BaseController

  respond_to :json

  def create
    issuance = Issuance.find params[:issuance_id]
    head :unauthorized and return unless request.headers['authorization'] == "ApplePass #{issuance.registration_secret}"
    registration = issuance.registrations.first_or_initialize :device_library_identifier => params[:device_library_identifier]
    registration.push_token = params[:pushToken]
    head registration.new_record? && :created || :ok
    registration.save
  end

  def destroy
    issuance = Issuance.find params[:issuance_id]
    head :unauthorized and return unless request.headers['authorization'] == "ApplePass #{issuance.registration_secret}"
    issuance.registrations.where(:device_library_identifier => params[:device_library_identifier]).destroy_all
    head :ok
  end

  def index
    # TODO: If I address revocation then un-scope registration, that way it'll be updated
    registrations = Registration.where :device_library_identifier => params[:device_library_identifier]
    registrations = registrations.where 'updated_at > ?', DateTime.parse(params[:passesUpdatedSince]) if params[:passesUpdatedSince]
    head :no_content and return if registrations.count == 0
    respond_with ({
      :lastUpdated => Time.now.utc.iso8601,
      :serialNumbers => registrations.map(&:id).map(&:to_s)
    })
  end

  def show
    begin
      issuance = Issuance.find params[:issuance_id]
      head :unauthorized and return unless request.headers['authorization'] == "ApplePass #{issuance.registration_secret}"
      head :not_modified and return unless stale? :last_modified => issuance.updated_at.utc
      send_file issuance.path
    rescue ActiveRecord::RecordNotFound
      # TODO: Decide what to do on revocation
      head :not_modified
    end
  end

end
