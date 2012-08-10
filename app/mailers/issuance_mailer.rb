class IssuanceMailer < ActionMailer::Base

	default :from => 'AppBlade Support <support@appblade.com>', :reply_to => "support@appblade.com"

	def sign_up(issuance_id)
		@issuance = Issuance.find(issuance_id, include: :instance)
		@instance = @issuance.instance
		attachments["pass.pkpass"] = File.read(@issuance.path)
		mail :to => @issuance.email, subject: "Welcome to PassKit"
	end

	def event_updated(issuance_id)
		@issuance = Issuance.find(issuance_id, include: :instance)
		@instance = @issuance.instance
		attachments["pass.pkpass"] = File.read(@issuance.path)
		mail :to => @issuance.email, subject: "#{@instance.description} has been updated"
	end
end