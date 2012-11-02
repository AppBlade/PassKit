class Registration < ActiveRecord::Base

  attr_accessible :device_library_identifier, :issuance_id, :push_token

end
