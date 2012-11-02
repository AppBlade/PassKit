class Registration < ActiveRecord::Base

  attr_accessible :device_library_identifier, :issuance_id, :push_token

  default_scope where(:deleted_at => nil)

  def destroy
    self.deleted_at = Time.now
    save
  end

end
