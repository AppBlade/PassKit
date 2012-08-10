class Issuance < ActiveRecord::Base

	attr_accessible :barcode_alt_text, :barcode_format, :barcode_message, :barcode_message_encoding, :email, :instance_id

	belongs_to :instance, :touch => true

end
