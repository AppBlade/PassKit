class IssuanceMailer < ActionMailer::Base

	default :from => 'AppBlade Support <support@appblade.com>', :reply_to => "support@appblade.com"

	def sign_up(issuance_id)
		@issuance = Issuance.find(issuance_id)
		mail :to => @issuance.email, subject: "Welcome to PassKit"
	end

end