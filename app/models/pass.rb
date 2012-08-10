class Pass < ActiveRecord::Base

	attr_accessible :description, :organization_name, :pass_type_identifier, :team_identifier

	has_many :instances, :dependent => :destroy

	def to_s
		pass_type_identifier
	end

end
