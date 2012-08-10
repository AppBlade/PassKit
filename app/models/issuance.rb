class Issuance < ActiveRecord::Base

	attr_accessible :barcode_alt_text, :barcode_format, :barcode_message, :barcode_message_encoding, :email, :instance_id

	delegate  :icon, :icon_2x, :logo, :logo_2x, :background, :background_2x, :background_color, :foreground_color, :logo_text, :label_color, :description, :relevant_date, :pass, :organization_name, :pass_type_identifier, :team_identifier, :to => :instance
	delegate  :icon?, :icon_2x?, :logo?, :logo_2x?, :background?, :background_2x?, :background_color?, :foreground_color?, :label_color?, :to => :instance

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
=begin
				generic.headerFields [{key: 'title', label:"SOMETHING", value:"something"}, {key: 'title2', label:"SOMETHING", value:"something"}]
				generic.primaryFields [{key: 'something2', label:"SOMETHING", value:"SOMETHING ELSE"}]
				generic.secondaryFields [{key: 'something3', label:"SOMETHING", value:"SOMETHING ELSE"}]
				generic.auxiliaryFields [{key: 'something4', label:"SOMETHING", value:"SOMETHING ELSE"}]
				generic.backFields [{key: 'something5', label:"SOMETHING", value:"SOMETHING ELSE"}]
=end
			end
			issuance.relevantDate        relevant_date.utc.iso8601 if relevant_date
			issuance.backgroundColor     background_color unless background_color.blank?
			issuance.foregroundColor     foreground_color unless foreground_color.blank?
			issuance.labelColor          label_color unless label_color.blank?
			issuance.logoText            logo_text unless logo_text.blank?
			issuance.suppressStripShine  false
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

			manifest_data = {'pass.json' => OpenSSL::Digest::SHA1.hexdigest(to_builder.to_json)}

			manifest_data['icon.png']          = OpenSSL::Digest::SHA1.hexdigest(File.read(icon.path))          if icon?
			manifest_data['icon@2x.png']       = OpenSSL::Digest::SHA1.hexdigest(File.read(icon_2x.path))       if icon_2x?
			manifest_data['logo.png']          = OpenSSL::Digest::SHA1.hexdigest(File.read(logo.path))          if logo?
			manifest_data['logo@2x.png']       = OpenSSL::Digest::SHA1.hexdigest(File.read(logo_2x.path))       if logo_2x?
			manifest_data['background.png']    = OpenSSL::Digest::SHA1.hexdigest(File.read(background.path))    if background?
			manifest_data['background@2x.png'] = OpenSSL::Digest::SHA1.hexdigest(File.read(background_2x.path)) if background_2x?

			manifest = Tempfile.new('manifest')
			manifest.write manifest_data.to_json
			manifest.close

			signature = Tempfile.new('signature', :encoding => 'ASCII-8BIT')
		 	signature.write	OpenSSL::PKCS7.sign(pass.pkcs12.certificate, pass.pkcs12.key, manifest_data.to_json, nil, OpenSSL::PKCS7::BINARY | OpenSSL::PKCS7::NOATTR | OpenSSL::PKCS7::DETACHED).to_der
			signature.close

			Zip::ZipFile.open "#{json.path}.pkpass", Zip::ZipFile::CREATE do |contents|
				contents.add 'background.png',    background.path     if background?
				contents.add 'background@2x.png', background_2x.path  if background_2x?
				contents.add 'pass.json',         json.path
				contents.add 'icon.png',          icon.path           if icon?
				contents.add 'icon@2x.png',       icon_2x.path        if icon_2x?
				contents.add 'logo.png',          logo.path           if logo?
				contents.add 'logo@2x.png',       logo_2x.path        if logo_2x?
				contents.add 'signature',         signature.path
				contents.add 'manifest.json',     manifest.path
			end
			
			return "#{json.path}.pkpass"

			json.unlink
			signature.unlink
	end

end
