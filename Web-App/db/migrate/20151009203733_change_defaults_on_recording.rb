class ChangeDefaultsOnRecording < ActiveRecord::Migration
  def change
    change_column :recordings, :scroll_speed, :integer, :default => 55
    change_column :recordings, :font_size, :integer, :default => 40
  end
end
