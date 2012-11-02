class Issuance < ActiveRecord::Base

	attr_accessible :barcode_alt_text, :email, :instance_id

	delegate  :barcode_format, :barcode_message_encoding, :icon, :icon_2x, :logo, :logo_2x, :background, :background_2x, :background_color, :foreground_color, :logo_text, :label_color, :description, :relevant_date, :pass, :organization_name, :pass_type_identifier, :team_identifier, :to => :instance
	delegate  :icon?, :icon_2x?, :logo?, :logo_2x?, :background?, :background_2x?, :background_color?, :foreground_color?, :label_color?, :to => :instance

	belongs_to :instance, :touch => true

  has_many :registrations
  
  before_create :generate_registration_secret

	def to_builder
		Jbuilder.new.tap do |issuance|
			issuance.description         description
			issuance.formatVersion       1
			issuance.organizationName    organization_name
			issuance.passTypeIdentifier  pass_type_identifier
			issuance.serialNumber        id.to_s
			issuance.teamIdentifier      team_identifier
			issuance.generic do |generic|
				generic.headerFields    [{key: 'title', label:"SOMETHING", value:"something"}, {key: 'title2', label:"SOMETHING", value:"something"}]
				generic.primaryFields   [{key: 'something2', label:"SOMETHING", value:"Primary field"}]
				generic.secondaryFields [{key: 'something3', label:"SOMETHING", value:"Secondary field"}]
				generic.auxiliaryFields [{key: 'something4', label:"SOMETHING", value:"Auxilary field"}]
				generic.backFields      [{key: 'something5', label:"SOMETHING", value:"Back field"}]
			end
			issuance.relevantDate        relevant_date.utc.iso8601 if relevant_date
			issuance.backgroundColor     background_color unless background_color.blank?
			issuance.foregroundColor     foreground_color unless foreground_color.blank?
			issuance.labelColor          label_color unless label_color.blank?
			issuance.logoText            logo_text unless logo_text.blank?
			issuance.suppressStripShine  false
			issuance.authenticationToken registration_secret
   		issuance.webServiceURL       'https://james.showoff.io/api'
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
      intermediate = OpenSSL::X509::Certificate.new <<X509
-----BEGIN CERTIFICATE-----
MIIEIzCCAwugAwIBAgIBGTANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzET
MBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMDgwMjE0MTg1
NjM1WhcNMTYwMjE0MTg1NjM1WjCBljELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFw
cGxlIEluYy4xLDAqBgNVBAsMI0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVs
YXRpb25zMUQwQgYDVQQDDDtBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0
aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMo4VKbLVqrIJDlI6Yzu7F+4fyaRvDRTes58Y4Bhd2RepQcj
tjn+UC0VVlhwLX7EbsFKhT4v8N6EGqFXya97GP9q+hUSSRUIGayq2yoy7ZZjaFIV
PYyK7L9rGJXgA6wBfZcFZ84OhZU3au0Jtq5nzVFkn8Zc0bxXbmc1gHY2pIeBbjiP
2CsVTnsl2Fq/ToPBjdKT1RpxtWCcnTNOVfkSWAyGuBYNweV3RY1QSLorLeSUheHo
xJ3GaKWwo/xnfnC6AllLd0KRObn1zeFM78A7SIym5SFd/Wpqu6cWNWDS5q3zRinJ
6MOL6XnAamFnFbLw/eVovGJfbs+Z3e8bY/6SZasCAwEAAaOBrjCBqzAOBgNVHQ8B
Af8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUiCcXCam2GGCL7Ou6
9kdZxVJUo7cwHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01/CF4wNgYDVR0f
BC8wLTAroCmgJ4YlaHR0cDovL3d3dy5hcHBsZS5jb20vYXBwbGVjYS9yb290LmNy
bDAQBgoqhkiG92NkBgIBBAIFADANBgkqhkiG9w0BAQUFAAOCAQEA2jIAlsVUlNM7
gjdmfS5o1cPGuMsmjEiQzxMkakaOY9Tw0BMG3djEwTcV8jMTOSYtzi5VQOMLA6/6
EsLnDSG41YDPrCgvzi2zTq+GGQTG6VDdTClHECP8bLsbmGtIieFbnd5G2zWFNe8+
0OJYSzj07XVaH1xwHVY5EuXhDRHkiSUGvdW0FY5e0FmXkOlLgeLfGK9EdB4ZoDpH
zJEdOusjWv6lLZf3e7vWh0ZChetSPSayY6i0scqP9Mzis8hH4L+aWYP62phTKoL1
fGUuldkzXfXtZcwxN8VaBOhr4eeIA0p1npsoy0pAiGVDdd3LOiUjxZ5X+C7O0qmS
XnMuLyV1FQ==
-----END CERTIFICATE-----
X509

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
		 	signature.write	OpenSSL::PKCS7.sign(pass.pkcs12.certificate, pass.pkcs12.key, manifest_data.to_json, [pass.pkcs12.certificate, intermediate], OpenSSL::PKCS7::BINARY | OpenSSL::PKCS7::NOATTR | OpenSSL::PKCS7::DETACHED).to_der
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

private

  def generate_registration_secret
    self.registration_secret = SecureRandom.hex(32)
  end

end
