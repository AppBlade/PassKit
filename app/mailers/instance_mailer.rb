class InstanceMailer < ActionMailer::Base

	def instance_updated(issuance_id, instance_id)
		@issuance = Issuance.find(issuance_id)
		@instance = Instance.find(instance_id)
		mail :to => @issuance.email, subject: "#{@instance.name} has been updated"
	end

end