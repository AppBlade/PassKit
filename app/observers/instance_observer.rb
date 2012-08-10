class InstanceObserver < ActiveRecord::Observer

	def after_update(instance)	
		InstanceMailer.instance_updated(instance.id).deliver!
	end

end