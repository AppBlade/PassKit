class MoveEncodingAndBarcodeJazz < ActiveRecord::Migration
  def up
    add_column :instances, :barcode_format, :string
    add_column :instances, :barcode_message_encoding, :string
    remove_column :issuances, :barcode_format
    remove_column :issuances, :barcode_message_encoding
  end

  def down
    remove_column :instances, :barcode_format
    remove_column :instances, :barcode_message_encoding
    add_column :issuances, :barcode_format, :string
    add_column :issuances, :barcode_message_encoding, :string
  end
end
