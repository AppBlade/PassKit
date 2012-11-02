class AddDeletedAt < ActiveRecord::Migration
  def up
    add_column :registrations, :deleted_at, :datetime
  end
end
