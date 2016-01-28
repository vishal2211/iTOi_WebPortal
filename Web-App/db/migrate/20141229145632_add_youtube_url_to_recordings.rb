class AddYoutubeUrlToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :youtube_url, :string
  end
end
