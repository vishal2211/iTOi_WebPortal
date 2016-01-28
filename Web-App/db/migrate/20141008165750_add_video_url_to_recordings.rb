class AddVideoUrlToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :video_url, :string
  end
end
