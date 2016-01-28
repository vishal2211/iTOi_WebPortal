class AddVideoBackgroundColorToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :video_background_color, :string, :default => "0/0/0"
  end
end
