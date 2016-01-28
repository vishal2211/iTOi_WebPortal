class AddTranscodedVideoUrlToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :transcoded_video_url, :string
  end
end
