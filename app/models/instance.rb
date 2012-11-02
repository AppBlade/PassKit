class Instance < ActiveRecord::Base

	attr_accessible :remove_icon, :barcode_format, :barcode_message_encoding, :remove_logo, :remove_background, :description, :relevant_date, :pass_id, :icon, :icon_2x, :logo, :logo_2x, :background, :background_2x, :remove_icon, :remove_icon_2x, :remove_logo, :remove_logo_2x, :remove_background, :remove_background_2x, :background_color, :foreground_color, :label_color, :logo_text, :suppress_strip_shine

	delegate :organization_name, :pass_type_identifier, :team_identifier, :to => :pass

	belongs_to :pass, :touch => true

	has_many :issuances, :dependent => :destroy

	BarcodeFormats = %w(PKBarcodeFormatQR PKBarcodeFormatPDF417 PKBarcodeFormatAztec)
	BarcodeMessageEncodings = %w(iso-8859-1)

	mount_uploader :logo,          ImageUploader
	mount_uploader :logo_2x,       ImageUploader
	mount_uploader :background,    ImageUploader
	mount_uploader :background_2x, ImageUploader
	mount_uploader :icon,          ImageUploader
	mount_uploader :icon_2x,       ImageUploader

	def to_s
		description
	end

end
