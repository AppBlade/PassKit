class IssuanceObserver < ActiveRecord::Observer

	def after_create(issuance)	
		IssuanceMailer.sign_up(issuance.id).deliver
	end

end