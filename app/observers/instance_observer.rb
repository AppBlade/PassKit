class InstanceObserver < ActiveRecord::Observer

	def after_update(instance)	
		# This is wrong. We need a better way to update users about updates. 
		# InstanceMailer.instance_updated(instance.id).deliver!
	end

end