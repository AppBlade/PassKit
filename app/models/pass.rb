class Pass < ActiveRecord::Base

	attr_accessible :p12_file, :p12_passcode

	has_many :instances, :dependent => :destroy
	has_many :issuances, :through => :instances

	mount_uploader :p12_file, P12Uploader

	before_validation :check_p12

	def pkcs12
		@pkcs12 ||= OpenSSL::PKCS12.new File.read(p12_file.path), p12_passcode
	end

	def certificate
		pkcs12.certificate
	end

	def key
		pkcs12.key
	end

	def to_s
		pass_type_identifier
	end

private

	def check_p12
		if p12_file_changed?
			begin
				self.organization_name    = certificate.subject.to_a[3][1]
				self.pass_type_identifier = certificate.subject.to_a[0][1]
				self.team_identifier      = certificate.subject.to_a[2][1]
			rescue OpenSSL::PKCS12::PKCS12Error
				self.errors.add :p12_passcode, "doesn't match"
			end
		end
	end

end
