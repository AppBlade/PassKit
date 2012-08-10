class InstanceMailer < ActionMailer::Base

	def instance_updated(instance_id)
		@issuance = Issuance.find(issuance_id)
		@instance = @issuance.instance
		mail :to => @issuance.email, subject: "#{@instance.name} has been updated"
	end

end