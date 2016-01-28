class AddScrollSpeedToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :scroll_speed, :integer
  end
end
