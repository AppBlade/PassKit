class Instance < ActiveRecord::Base

	attr_accessible :description, :relevant_date, :pass_id

	belongs_to :pass, :touch => true

	def to_s
		description
	end

end
