class CreateInstances < ActiveRecord::Migration
  def change
		remove_column :passes, :description
    create_table :instances do |t|
      t.datetime :relevant_date
      t.string :description
			t.integer :pass_id
      t.timestamps
    end
  end
end
