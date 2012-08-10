class AddStyleFields < ActiveRecord::Migration
  def change
		add_column :instances, :logo, :string
		add_column :instances, :logo_2x, :string
		add_column :instances, :background, :string
		add_column :instances, :background_2x, :string
		add_column :instances, :icon, :string
		add_column :instances, :icon_2x, :string

		add_column :instances, :background_color, :string
		add_column :instances, :foreground_color, :string
		add_column :instances, :label_color, :string

		add_column :instances, :logo_text, :string
		add_column :instances, :suppress_strip_shine, :boolean
	end
end
