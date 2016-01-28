class AddDurationToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :duration, :decimal, :null => false, :precision => 10, :scale => 3, :default => 0
    remove_column :users, :used_video_space_minutes
  end
end
