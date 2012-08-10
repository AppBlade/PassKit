class CreateIssuances < ActiveRecord::Migration
  def change
    create_table :issuances do |t|
      t.integer :instance_id
      t.string :barcode_alt_text
      t.string :barcode_format
      t.string :barcode_message
      t.string :barcode_message_encoding
      t.string :email

      t.timestamps
    end
  end
end
