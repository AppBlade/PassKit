class UpdatePassToP12Jazz < ActiveRecord::Migration
  def change
		add_column :passes, :p12_file, :string
		add_column :passes, :p12_passcode, :string
	end
end
