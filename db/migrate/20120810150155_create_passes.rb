class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.string :description
      t.string :organization_name
      t.string :pass_type_identifier
      t.string :team_identifier
      t.timestamps
    end
  end
end
