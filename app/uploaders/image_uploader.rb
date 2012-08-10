class ImageUploader < CarrierWave::Uploader::Base

	storage :file

	def store_path(for_file = filename)
		"system/instances/#{model.id}/#{for_file}"
	end

	def extension_white_list
		%w(png)
	end

end
