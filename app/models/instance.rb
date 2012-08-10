class Instance < ActiveRecord::Base

	attr_accessible :description, :relevant_date, :pass_id

	belongs_to :pass, :touch => true

	has_many :issuances, :dependent => :destroy

	def to_s
		description
	end

end
