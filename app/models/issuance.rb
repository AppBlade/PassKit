class Issuance < ActiveRecord::Base

	attr_accessible :barcode_alt_text, :barcode_format, :barcode_message, :barcode_message_encoding, :email, :instance_id

	delegate :description, :relevant_date, :pass, :organization_name, :pass_type_identifier, :team_identifier, :to => :instance

	belongs_to :instance, :touch => true

	BarcodeFormats = %w(PKBarcodeFormatQR PKBarcodeFormatPDF417 PKBarcodeFormatAztec)
	BarcodeMessageEncodings = %w(iso-8859-1)

	def to_builder
		Jbuilder.new.tap do |issuance|
			issuance.description         description
			issuance.formatVersion       1
			issuance.organizationName    organization_name
			issuance.passTypeIdentifier  pass_type_identifier
			issuance.serialNumber        id.to_s
			issuance.teamIdentifier      team_identifier
			issuance.generic do |generic|
			end
			issuance.relevantDate        relevant_date.utc.iso8601 if relevant_date
#			issuance.authenticationToken '123'
# 		issuance.webServiceURL       'https://localhost'
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

			icon = File.open('/Users/james/Desktop/raizlabs/icon.png')
			icon_2x = File.open('/Users/james/Desktop/raizlabs/icon@2x.png')
			logo = File.open('/Users/james/Desktop/raizlabs/logo.png')

			manifest_data = {
				'pass.json'   => OpenSSL::Digest::SHA1.hexdigest(to_builder.to_json), 
				'icon.png'    => OpenSSL::Digest::SHA1.hexdigest(icon.read),
				'icon@2x.png' => OpenSSL::Digest::SHA1.hexdigest(icon_2x.read),
				'logo.png'    => OpenSSL::Digest::SHA1.hexdigest(logo.read)
			}.to_json

			manifest = Tempfile.new('manifest')
			manifest.write manifest_data
			manifest.close

			signature = Tempfile.new('signature', :encoding => 'ASCII-8BIT')
		 	signature.write	OpenSSL::PKCS7.sign(pass.pkcs12.certificate, pass.pkcs12.key, manifest_data, nil, OpenSSL::PKCS7::BINARY | OpenSSL::PKCS7::NOATTR | OpenSSL::PKCS7::DETACHED).to_der
			signature.close

			Zip::ZipFile.open "#{json.path}.pkpass", Zip::ZipFile::CREATE do |contents|
				#contents.add 'background.png',    background.path
				#contents.add 'background@2x.png', background_2x.path
				contents.add 'pass.json',         json.path
				contents.add 'icon.png',          icon.path
				contents.add 'icon@2x.png',       icon_2x.path
				contents.add 'logo.png',          logo.path
				#contents.add 'logo@2x.png',       logo_2x.path
				contents.add 'signature',         signature.path
				contents.add 'manifest.json',     manifest.path
			end
			
			return "#{json.path}.pkpass"

			json.unlink
			signature.unlink
	end

end
