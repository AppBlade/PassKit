class Issuance < ActiveRecord::Base

	attr_accessible :barcode_alt_text, :barcode_format, :barcode_message, :barcode_message_encoding, :email, :instance_id

	delegate :description, :relevant_date, :pass, :organization_name, :pass_type_identifier, :team_identifier, :to => :instance

	belongs_to :instance, :touch => true

	def to_builder
		Jbuilder.new.tap do |issuance|
			issuance.description         description
			issuance.formatVersion       1
			issuance.organizationName    organization_name
			issuance.passTypeIdentifier  pass_type_identifier
			issuance.serialNumber        id
			issuance.teamIdentifier      team_identifier
			issuance.relevantDate        relevant_date.utc.iso8601 if relevant_date
			issuance.authenticationToken '123'
			issuance.webServiceURL       'https://localhost'
			issuance.barcode do |barcode|
				barcode.altText         barcode_alt_text unless barcode_alt_text.blank?
				barcode.format          barcode_format
				barcode.message         barcode_message
				barcode.messageEncoding barcode_message_encoding
			end
			issuance.locations [] do |location|
				location.latitude    37.296
				location.longitude  -122.038
				location.altitude    0 if false
			end
		end
	end

	def path
			json = Tempfile.new('passkey')
			json.write to_builder.to_json
			json.close
			Zip::ZipFile.open "#{json.path}.pkpass", Zip::ZipFile::CREATE do |contents|
				#zipfile.add 'background.png',    background.path
				#zipfile.add 'background@2x.png', background_2x.path
				contents.add 'pass.json',         json.path
				#zipfile.add 'icon.png',          icon.path
				#zipfile.add 'icon@2x.png',       icon_2x.path
				#zipfile.add 'logo',              logo.path
				#zipfile.add 'logo@2x.png',       logo_2x.path
				#zipfile.add 'signature',         ''
			end
			return "#{json.path}.pkpass"
			json.unlink
	end

end
