class Instance < ActiveRecord::Base

	attr_accessible :description, :relevant_date, :pass_id

	delegate :organization_name, :pass_type_identifier, :team_identifier, :to => :pass

	belongs_to :pass, :touch => true

	has_many :issuances, :dependent => :destroy

	def to_s
		description
	end

end
