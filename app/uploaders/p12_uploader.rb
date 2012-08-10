class P12Uploader < CarrierWave::Uploader::Base

	storage :file

	def store_path(for_file = filename)
		"system/#{model.id}/#{for_file}"
	end

	def extension_white_list
		%w(p12)
	end

end

