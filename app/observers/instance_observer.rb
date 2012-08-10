class InstanceObserver < ActiveRecord::Observer

	def after_update(instance)	
		# Todo we probably want to group by email in the future
		instance.issuances.each do |i|
			IssuanceMailer.event_updated(i.id).deliver
		end
	end

end