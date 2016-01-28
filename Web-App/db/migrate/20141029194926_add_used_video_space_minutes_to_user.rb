class AddUsedVideoSpaceMinutesToUser < ActiveRecord::Migration
  def change
    add_column :users, :used_video_space_minutes, :integer, :null => false, :default => 0
  end
end
