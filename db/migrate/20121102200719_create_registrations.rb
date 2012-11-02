class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :issuance_id
      t.string :push_token
      t.string :device_library_identifier
      t.timestamps
    end
    add_column :issuances, :registration_secret, :string
    Issuance.all.each do |issuance|
      issuance.send :generate_registration_secret
      issuance.save
    end
  end
end
