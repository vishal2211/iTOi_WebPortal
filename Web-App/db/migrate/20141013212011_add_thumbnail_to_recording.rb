class AddThumbnailToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :thumbnail_url, :string
  end
end
